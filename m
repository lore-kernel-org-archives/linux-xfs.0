Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBVCk3Tf233974 for <xfs@oss.sgi.com>; Sat, 31 Dec 2011 06:46:03 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id HfvTcgjmJjNPqHgQ
	for <xfs@oss.sgi.com>; Sat, 31 Dec 2011 04:46:01 -0800 (PST)
Received: by lagr15 with SMTP id r15so7066933lag.26
	for <xfs@oss.sgi.com>; Sat, 31 Dec 2011 04:46:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111230204307.GN23662@dastard>
References: <4efc665b.d139e30a.2f32.fffff97a@mx.google.com>
	<20111229205745.GH12731@dastard>
	<CADDb1s18XsCRkjq_spMKx0-4g2H51mRJXn=u=boqUe4TXZw-MQ@mail.gmail.com>
	<20111230204307.GN23662@dastard>
Date: Sat, 31 Dec 2011 18:16:00 +0530
Message-ID: <CADDb1s0896uUWMwDXwXeHg+YgEHBD606m9amXrGV6YxVAWqO4Q@mail.gmail.com>
Subject: Re: Preallocation with direct IO?
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Dec 31, 2011 at 2:13 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Dec 30, 2011 at 08:37:00AM +0530, Amit Sahrawat wrote:
>> On Fri, Dec 30, 2011 at 2:27 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > On Thu, Dec 29, 2011 at 01:10:49PM +0000, amit.sahrawat83@gmail.com wr=
ote:
>> >> Hi, I am using a test setup which is doing write using multiple
>> >> threads using direct IO. The buffer size which is used to write is
>> >> 512KB. =A0After continously running this for long duration - i
>> >> observe that number of extents in each file is getting
>> >> huge(2K..4K..). I observed that each extent is of 512KB(aligned to
>> >> write buffer size). I wish to have low number of extents(i.e,
>> >> reduce fragmentation)... In case of buffered IO- preallocation
>> >> works good alongwith the mount option 'allocsize'. Is there
>> >> anything which can be done for Direct IO? =A0Please advice for
>> >> reducing fragmentation with direct IO.
>> >
>> > Direct IO does not do any implicit preallocation. The filesystem
>> > simply gets out of the way of direct IO as it is assumed you know
>> > what you are doing.
>> This is the supporting line I was looking for.
>> >
>> > i.e. you know how to use the fallocate() or ioctl(XFS_IOC_RESVSP64)
>> > calls to preallocate space or to set up extent size hints to use
>> > larger allocations than the IO being done during syscalls...
>> I tried to make use of preallocating space using
>> ioctl(XFS_IOC_RESVSP64) - but over time - this is also not working
>> well with the Direct I/O.
>
> Without knowing how you are using preallocation, I cannot comment on
> this. Can you describe how your application does IO (size,
> frequency, location in file, etc) and preallocation (same again), as
> well as xfs_bmap -vp <file> output of fragmented files? That way I
> have some idea of what your problem is and so might be able to
> suggest fixes...
Prealloction was done using - snippets like these:
        fl.l_whence =3D SEEK_SET;
        fl.l_start =3D 0;
        fl.l_len =3D (long long) PREALLOC;       /* 1GB */
        printf ("Preallocating %lld MB\n", (fl.l_len / (1024 * 1024)));
        err =3D ioctl (hFile, XFS_IOC_RESVSP64, &fl);
I verified the prealloc working by taking a look at the file size (ls
-l) disk usage using 'df -kh' and also taking a look at the file
extents using xfs_bmap
xfs_bmap shows the extent of the preallocated length.
i.e., preallocation was working as expected.

To share the test case, due to some reasons - I cannot share the exact
code - but the working is like this:

In the Test case - there are 5 threads
WRITE_SIZE  - 512KB
TRUNCSIZE - 250MB
1st Thread - this is doing actual amongst all the threads
	buffer =3D valloc(WRITE_SIZE);
	fd=3D open64(file,O_CREAT|O_DIRECT|O_WRONLY|O_TRUNC)
	Initial write to file data of 5GB using 512KB buffer size
	for(i=3D0; i < WRITE_COUNT; i++)
	{
		write(fd, buffer,WRITE_SIZE);
	}
	fsync(fd)
	while(1)
	{
		if(ncount++ < TRUNCSIZE)	=

		{
			write(fd,buffer,WRITE_SIZE);
		}
		else
		{
			close(fd)
			open(fd, O_RDWR|O_CREAT)
			gettimeofday() - Start Point
			sync(fd); // At times this sync is taking time around 5sec even
though the test case is doing I/O using O_DIRECT
			gettimeofday() - End Point
			If(sync time greater than 2secs)
				exit(0);
			gettimeofday() - Start Point
			ftruncate(fd,TRUNCSIZE);
			gettimeofday() - End Point

			if(truncate time greater than 2sec)
				exit(0);	=

			fsync(fd)
			close(fd);	=


			open64(file, O_WRONLY|O_APPEND|O_DIRECT);
			ncount =3D 0;		=

		}
		fsync(fd);
	}

2nd Thread - Writing to a file in while loop
	while (1)
	{
		write(10 bytes)
		fsync();
		usleep(100 * 1000);
	}
3rd Thread - Reading the file from 2nd Thread
	while(1){
		read(file, buffer,10);
		lseek(file, 0,0);
		usleep(10000);
		=

	}
4th thread - Just printing the the size information for the '2' files
which are written
5th thread - Also, reading the file from 2nd thread

>
>> Is there any call to set up extent size
>> also? please update I can try to make use of that also.
>
> `man xfsctl` and search for XFS_IOC_FSSETXATTR.
thanks Dave, this is exactly what was needed - this is working as of now.

But there continues to be a problem with the sync time. Even though
there is no dirty data - but still sync is taking time around 5sec(but
this is very rare - and observed very few times in overnight runnings)
So, also very difficult to debug what could be the issue and who could
be culprit. At one time - tried to check the trace during this sync
time issue - please find as given below:

(dump_backtrace+0x0/0x11c) from [<c0389520>] (dump_stack+0x20/0x24)
(dump_stack+0x0/0x24) from [<c0067b70>] (__schedule_bug+0x7c/0x8c)
(__schedule_bug+0x0/0x8c) from [<c0389bc0>] (schedule+0x88/0x5fc)
(schedule+0x0/0x5fc) from [<c020a0c8>] (_xfs_log_force+0x238/0x28c)
(_xfs_log_force+0x0/0x28c) from [<c020a320>] (xfs_log_force+0x20/0x40)
(xfs_log_force+0x0/0x40) from [<c02308c4>] (xfs_commit_dummy_trans+0xc8/0xd=
4)
(xfs_commit_dummy_trans+0x0/0xd4) from [<c0231468>] (xfs_quiesce_data+0x60/=
0x88)
(xfs_quiesce_data+0x0/0x88) from [<c022e080>] (xfs_fs_sync_fs+0x2c/0xe8)
(xfs_fs_sync_fs+0x0/0xe8) from [<c015cccc>] (__sync_filesystem+0x8c/0xa8)
(__sync_filesystem+0x0/0xa8) from [<c015cd1c>] (sync_one_sb+0x34/0x38)
(sync_one_sb+0x0/0x38) from [<c013b1f0>] (iterate_supers+0x7c/0xc0)
(iterate_supers+0x0/0xc0) from [<c015cbf4>] (sync_filesystems+0x28/0x34)
(sync_filesystems+0x0/0x34) from [<c015cd68>] (sys_sync+0x48/0x78)
(sys_sync+0x0/0x78) from [<c003b4c0>] (ret_fast_syscall+0x0/0x48)

In order to resolve this -  applied the below patche:
xfs: dummy transactions should not dirty VFS state
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dcom=
mitdiff;h=3D1a387d3be2b30c90f20d49a3497a8fc0693a9d18
But still continued to observe the sync timing issue.

One thing, do we need fsync() - when performing write using O_DIRECT?I
think 'no'
Also, should sync() be taking time when there is no 'dirty' data?

Please share your opinion.

Thanks & Regards,
Amit Sahrawat



>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
