Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DD77802E
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 20:59:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0E3C304059
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 18:59:05 -0700 (PDT)
Received: from mail-yh0-f53.google.com (mail-yh0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 80AVtV8HUvbuBOTK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Apr 2014 18:59:03 -0700 (PDT)
Received: by mail-yh0-f53.google.com with SMTP id v1so264935yhn.40
	for <xfs@oss.sgi.com>; Mon, 07 Apr 2014 18:59:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEH94LiJ6PBRRdFc4aZapLEPT7B7==0dUKQZqzQ6+vQpGpxHLg@mail.gmail.com>
References: <CAEH94LiJ6PBRRdFc4aZapLEPT7B7==0dUKQZqzQ6+vQpGpxHLg@mail.gmail.com>
Date: Tue, 8 Apr 2014 09:59:02 +0800
Message-ID: <CAEH94Lj8Q9247c=zrkJHyzFmGYGzK-DL9nvX2tkcxkJ=EkJcAA@mail.gmail.com>
Subject: Re: [Bug] XFS: DIO random write + BufferIO read
From: Zhi Yong Wu <zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfstests <xfs@oss.sgi.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

any comments?

On Fri, Apr 4, 2014 at 11:09 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> HI
>
> When i try something on XFS filesytem, i hit one issue as below:
>
> One main task create multiple threads at first, Then it will dio
> random write some files with random offset and length for each thread.
> When those files get ready, those multiple threads will bufferio read
> them and check if the data are same as their corresponding buffer. In
> theory, they should be same, but the actual result isn't what we
> expect
>
> By the way, i did the same try on ext3 filesystem, but didn't get any
> such issue.
>
> Below is the test code:
>
> #include <errno.h>
> #include <string.h>
> #include <time.h>
> #include <pthread.h>
> #include <assert.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <libaio.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <syscall.h>
> #include <fcntl.h>
> #include <libaio.h>
> #include <string>
> #include <vector>
>
> using namespace std;
>
> #define AIO_BLKSIZE  4096
> #define AIO_MAXIO 64
>
> static long gettid()
> {
>     return static_cast<long>(pthread_self());
> }
>
> static void* aioThreadWrapper(void* arg);
>
> class DioTest;
> struct cbParam {
>     cbParam(DioTest* p, int fileseq) :p_(p), fileseq_(fileseq) {}
>
>     DioTest* p_;
>     int fileseq_;
> };
>
>
> class DioTest
> {
>     public:
>         DioTest(const char* name) {
>             filename = name;
>             memset(&myctx, 0, sizeof(myctx));
>             io_queue_init(AIO_MAXIO, &myctx);
>             pthread_t tid;
>             pthread_create(&tid, NULL, aioThreadWrapper, this);
>         }
>
>         void wr_done(int fileseq, struct iocb *iocb, long res, long res2) {
>             close(iocb->aio_fildes);
>
>             if (res2 != 0) {
>                 printf("aio write error n");
>                 abort();
>             }
>             if (res != iocb->u.c.nbytes) {
>                 printf("write missed bytes expect %ld got %ld n",
>                         iocb->u.c.nbytes, res);
>                 abort();
>             }
>             size_t length = iocb->u.c.nbytes;
>             size_t offset = iocb->u.c.offset;
>             char path[1024];
>             snprintf(path, sizeof(path), "%s%d", filename, fileseq);
>             int fd = open(path, O_RDONLY);
>             assert(fd >= 0);
>             char* readbuf = (char*)malloc(length);
>             assert(readbuf);
>
>             memset(readbuf, 0, length);
>             ssize_t ret = pread(fd, readbuf, length, offset);
>             assert (ret == length);
>             close(fd);
>
>             int cmp = memcmp(readbuf, iocb->u.c.buf, length);
>             if (cmp != 0)
>             {
>                 printf("tid=%ld data dismatch.cmp=%d file=%s
> offset=%lu length=%lu!\n",
>                         gettid(), cmp, path, offset, length);
>                 abort();
>             }
>             printf("tid=%ld check=success file=%s offset=%lu length=%lu\n",
>                     gettid(), path, offset, length);
>
>             free(iocb->u.c.buf);
>             free(iocb);
>             free(readbuf);
>         }
>
>         bool writeRequest(int fileseq, size_t offset, size_t length) {
>             struct iocb *io = (struct iocb *)malloc(sizeof(struct iocb));
>             assert (io);
>             char path[1024];
>             snprintf(path, sizeof(path), "%s%d", filename, fileseq);
>             int fd  = open(path, O_RDWR|O_DIRECT|O_CREAT, S_IWUSR | S_IRUSR);
>             assert (fd >= 0);
>             void* buf=NULL;
>             int ret = posix_memalign(&buf, getpagesize(), length);
>             assert(ret == 0);
>             memset(buf, 'a', length);
>             io_prep_pwrite(io, fd, buf, length, offset);
>             io->data = new cbParam(this, fileseq);
>
>             int rc = io_submit(myctx, 1, &io);
>             if (rc < 0){
>                 printf("tid=%ld io_submit fail.file=%s offset=%lu
> length=%lu ret=%d errno=%s\n",
>                         gettid(), path, offset, length, ret, strerror(errno));
>                 close(fd);
>                 free(buf);
>                 delete (cbParam*)(io->data);
>                 free(io);
>                 return false;
>             }
>             assert (rc != 0);
>             printf("tid=%ld file=%s offset=%lu length=%lu\n",gettid(),
> path, offset, length);
>             return true;
>         }
>
>         void aioThread() {
>             while (true)
>             {
>                 struct io_event events[AIO_MAXIO];
>                 io_callback_t cb;
>                 int ret = io_getevents(myctx, 1, AIO_MAXIO, events, NULL);
>                 printf("tid=%ld %d io_request completed \n", gettid(), ret);
>
>                 for (int i = 0; i < ret; i++) {
>                     struct iocb *io = events[i].obj;
>                     printf("tid=%ld events[%d]res = %ld, res2 = %ld\n",
>                             gettid(), i, events[i].res, events[i].res2);
>
>                     cbParam* param = (cbParam*)io->data;
>                     DioTest* p = param->p_;
>                     p->wr_done(param->fileseq_, io, events[i].res,
> events[i].res2);
>                     delete param;
>                 }
>             }
>         }
>     private:
>         io_context_t myctx;
>         const char* filename;
> };
>
> static void* aioThreadWrapper(void* arg)
> {
>     DioTest* p = (DioTest*)arg;
>     p->aioThread();
>     return NULL;
> }
>
> int main(int args, char *argv[])
> {
>     if (args < 2) {
>         printf("./%s filename", argv[0]);
>         exit(1);
>     }
>     const char* filename = argv[1];
>     srand(time(NULL));
>     vector<DioTest*> dioTests;
>     const int threadNumber = 9;
>
>     for (int i = 0; i < threadNumber; ++i) {
>         dioTests.push_back(new DioTest(filename));
>     }
>
>     while (true) {
>         size_t offset = (rand() % (64*1024*1024/AIO_BLKSIZE)) * AIO_BLKSIZE;
>         size_t length = 0;
>         while (length == 0) {
>             length = abs(static_cast<int>(rand()*1.0/RAND_MAX*16))*AIO_BLKSIZE;
>         }
>
>         int seq = rand() % 100;
>         DioTest* p = dioTests[rand() % threadNumber];
>         for (int i = 0; i < 4; ++i){
>             p->writeRequest(seq, offset, length);
>             offset += (length + 4096);
>         }
>         usleep(rand() % 10000);
>     }
>     return 0;
> }
>
>
> --
> Regards,
>
> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
