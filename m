Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o07GYPk0192995
	for <linux-xfs@oss.sgi.com>; Thu, 7 Jan 2010 10:34:25 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46FBA14B135
	for <linux-xfs@oss.sgi.com>; Thu,  7 Jan 2010 08:35:17 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id vZyRGcAquGSk6k5R for
	<linux-xfs@oss.sgi.com>; Thu, 07 Jan 2010 08:35:17 -0800 (PST)
Message-ID: <26076.66.187.233.202.1262882117.squirrel@sandeen.net>
In-Reply-To: <5d96567b1001062337w105194c8u8eff888444709925@mail.gmail.com>
References: <5d96567b1001062337w105194c8u8eff888444709925@mail.gmail.com>
Date: Thu, 7 Jan 2010 10:35:17 -0600 (CST)
Subject: Re: how does sectsz is determined ?
From: "Eric Sandeen" <sandeen@sandeen.net>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Raz wrote:
> How does sectsz determined to be 512 or 4096 ?
> I have an xfs file system over software raid , and sometimes I have
> 1/2K sector size
> and sometimes 4K . Problem is that direct io buffers are aligned to
> 1/2k and not 4K.
> kernel is 2.6.18-8.el5. thank you.
> raz
>
>
> meta-data=/dev/md5               isize=256    agcount=33, agsize=10992384
> blks
>          =                       sectsz=4096  attr=0
> data     =                       bsize=4096   blocks=351780864, imaxpct=25
>          =                       sunit=768    swidth=768 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks
> realtime =none                   extsz=3145728 blocks=0, rtextents=0
>

for actual hardware sector size, see platform_findsizes(char *path, int
fd, long long *sz, int *bsz) :


        if (ioctl(fd, BLKSSZGET, bsz) < 0) {
                fprintf(stderr, _("%s: warning - cannot get sector size "
                                "from block device %s: %s\n"),
                        progname, path, strerror(errno));
                *bsz = BBSIZE;
        }

but also for software raid, which is more relevant to your case:

int
md_get_subvol_stripe(
        char            *dfile,
        sv_type_t       type,
        int             *sunit,
        int             *swidth,
        int             *sectalign,
        struct stat64   *sb)
{
...
                *sectalign = (md.level == 4 || md.level == 5 || md.level
== 6);
...
}

This sets ft->sectoralign,

        if (ft.sectoralign) {
                sectorsize = blocksize;
                sectorlog = libxfs_highbit32(sectorsize);
                if (loginternal) {
                        lsectorsize = sectorsize;
                        lsectorlog = sectorlog;
                }
        }

IOW we set "sector size" to the block size to avoid md switching cache
sizes...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
