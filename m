Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97DwtJV241586 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 08:58:56 -0500
Received: from nm13-vm0.bullet.mail.ne1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A55251C7335E
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 06:58:54 -0700 (PDT)
Received: from nm13-vm0.bullet.mail.ne1.yahoo.com
	(nm13-vm0.bullet.mail.ne1.yahoo.com [98.138.91.48]) by
	cuda.sgi.com with SMTP id ppZHwySgzRwbnXDK for
	<xfs@oss.sgi.com>; Fri, 07 Oct 2011 06:58:54 -0700 (PDT)
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
Message-ID: <1317995933.17433.YahooMailNeo@web122515.mail.ne1.yahoo.com>
Date: Fri, 7 Oct 2011 06:58:53 -0700 (PDT)
From: Bryan J Smith <b.j.smith@ieee.org>
Subject: Re: Premature "No Space left on device" on XFS
In-Reply-To: <20111007013711.GW3159@dastard>
MIME-Version: 1.0
Reply-To: Bryan J Smith <b.j.smith@ieee.org>
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
To: Dave Chinner <david@fromorbit.com>, Bernhard Schmidt <berni@birkenwald.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

[ Not really adding any technical meat, but just some past experience with =
XFS, plus Ext3 experience ]

I remember running into this a long time ago when I was first playing with =
XFS for /tmp and /var (I was still a Linux/XFS noob at the time, not that I=
'm an expert today).=A0 I ran into the same case where both free block and =
inodes were still available (although similarly well utilized), and the med=
ian file size was around 1KiB.=A0 It was also in the case of many small fil=
es being written out in a short period.

In my case, I didn't use the XFS debugger to get into the allocation of the=
 extents (would have if I wasn't such a noob, good, discrete command to kno=
w, thanx!).

Extents are outstanding for data and similar directories, ordering and plac=
ing large and small files to mitigate fragmentation.=A0 But in this case, a=
nd correct me if I'm wrong, it's really just a wasteful use for the extents=
 approach, as the files typically fit in a single data block or two.=A0 I m=
ean, I can still see some benefits in how inodes are allocated, but it seem=
s small compared to the overhead.=A0 Then add in the delete aspect, being t=
hat the files are not going to be retained in the user's use case here (thi=
s is a spool, correct?), and I'm not seeing XFS make sense.=A0 The fact tha=
t the services "fell behind" does not surprise me, although that's just a s=
ubjective feel (and if anyone knows how to back that up with good tools and=
 metrics, I'm all ears).

I never got around to benchmarking it against Ext3 in such a use case, but =
I quickly adopted a complementary Ext3+XFS volume approach.

I've used Ext3 with around 8 million files with a median size well under 4K=
iB (under 32GiB total).=A0 It works "well enough."=A0 I'm curious how Ext4 =
would do though.=A0 I think Ric Wheeler's team (at Red Hat) has done some b=
enchmarks on 7+ figure file counts on Ext3 and Ext4.=A0 I think I remember =
a couple of info and related tidbits back and forth when I was doing some E=
xt3 (with GFS and GFS2) testing, on expectations of performance.

Although can't say I've had 2 million files in a single directory, so YMMV.=
=A0 Then again, if it was extent overhead, it may not reach 2M to begin wit=
h.




----- Original Message -----
From: Dave Chinner <david@fromorbit.com>
Sent: Thursday, October 6, 2011 9:37 PM

On Thu, Oct 06, 2011 at 09:55:07PM +0200, Bernhard Schmidt wrote:
> ...
> It was=A0 bombarded with mails faster than it could send them on,
> which eventually led to almost 2 million files of ~1.5kB in one
> directory.=A0 Suddenly, this started to happen
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # touch a
> touch: cannot touch `a': No space left on device
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df .
> Filesystem=A0 =A0 =A0 =A0 =A0  1K-blocks=A0 =A0 =A0 Used Available Use% M=
ounted on
> /dev/sdb=A0 =A0 =A0 =A0 =A0 =A0 =A0 10475520=A0  7471160=A0  3004360=A0 7=
2%
> So you have a 10GB filesystem, with about 3GB of free space.
> /var/spool/postfix-bulk
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df -i .
> Filesystem=A0 =A0 =A0 =A0 =A0 =A0 Inodes=A0  IUsed=A0  IFree IUse% Mounte=
d on
> /dev/sdb=A0 =A0 =A0 =A0 =A0 =A0  10485760 1742528 8743232=A0  17% /var/sp=
ool/postfix-bulk

And with 1.7 million inodes in it. That's a lot for a tiny
filesystem, and not really a use case that XFS is well suited to.
XFS will work, but it won't age gracefully under these conditions...

As it is, your problem is most likely fragmented free space (an
aging problem). Inodes are allocated in chunks of 64, so require an
-aligned- contiguous 16k extent for the default 256 byte inode size.
If you have no aligned contiguous 16k extents free then inode
allocation will fail.

Running 'xfs_db -r "-c freesp -s" /dev/sdb' will give you a
histogram of free space extents in the filesystem, which will tell
us if you are hitting this problem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
