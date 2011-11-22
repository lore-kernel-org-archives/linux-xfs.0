Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMIqskT164117 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 12:52:55 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01FC01D11A62
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 10:52:52 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id HQM84De9x7EVdCsU for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 10:52:52 -0800 (PST)
Message-ID: <4ECBEF83.5020607@sandeen.net>
Date: Tue, 22 Nov 2011 12:52:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: EFSCORRUPTED on mount?
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
	<CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
	<20111122014114.GJ2386@dastard>
	<CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
In-Reply-To: <CAF3hT9Cu+56WJqzHVu+fMgquddwoMsfW-WC8CvRRBtC4PA3uHw@mail.gmail.com>
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
To: Gregory Farnum <gregory.farnum@dreamhost.com>
Cc: xfs@oss.sgi.com

On 11/22/11 12:47 PM, Gregory Farnum wrote:
> On Tue, Nov 22, 2011 at 7:06 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> > Others have had good comments but also:
>> >
>>> >> 2011-11-17 16:00:37.294876 7f83f3eef720 filestore(/mnt/osd.17)
>>> >> truncate meta/pginfo_12.7c8/0 size 0
>>> >> 2011-11-17 16:00:37.483407 7f83f3eef720 filestore(/mnt/osd.17)
>>> >> truncate meta/pginfo_12.7c8/0 size 0 = -117
>>> >> 2011-11-17 16:00:37.483476 7f83f3eef720 filestore(/mnt/osd.17)  error
>>> >> error 117: Structure needs cleaning not handled
>> >
>> > was there anything in dmesg/system logs right at this point?  XFS should
>> > have said something about this original error.
> Whoops. The following is a sample of what was in dmesg and kern.log
> after that point but before I did anything else (it repeated a lot but
> there weren't any other lines of output):
> xfs/xfs_buf.c.  Return address = 0xffffffff811c2aa8
> [56459.526220] XFS (sdg1): xfs_log_force: error 5 returned.
> [56489.544153] XFS (sdg1): xfs_log_force: error 5 returned.
> [56519.562087] XFS (sdg1): xfs_log_force: error 5 returned.
> [56549.580021] XFS (sdg1): xfs_log_force: error 5 returned.
> [56579.597956] XFS (sdg1): xfs_log_force: error 5 returned.
> [56609.615889] XFS (sdg1): xfs_log_force: error 5 returned.
> [56613.036430] XFS (sdg1): xfs_log_force: error 5 returned.

Ok, error 5 is EIO:

8 include/asm-generic/errno-base.h        8 #define EIO 5

So the very first error you saw was "xfs_do_force_shutdown(0x1) called from line..." ?
Or the "xfs_log_force error 5 returned?"  I'm wondering if there was more
before this.

It's worth looking carefully to see the very first problem reported by xfs,
and posibly from storage before that. (i.e. did your storage go wonky?)

-Eric

> [56613.041731] XFS (sdg1): xfs_do_force_shutdown(0x1) called from line
> 1037 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff811c2aa8
> [56619.430497] XFS (sdg1): xfs_log_force: error 5 returned.
> [56619.435796] XFS (sdg1): xfs_do_force_shutdown(0x1) called from line
> 1037 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff811c2aa8
> 
> Thanks!
> -Greg
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
