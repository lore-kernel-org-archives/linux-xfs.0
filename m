Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B76FC7F72
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 05:35:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50B5AAC002
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 03:35:18 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id yV67MgsYiTEPilVy (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 03:35:16 -0700 (PDT)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: xfs_fsr, sunit, and swidth
Date: Tue, 02 Apr 2013 12:34:53 +0200
Message-ID: <1938112.G9K3FbV7Ck@xrated>
In-Reply-To: <20130331012231.GJ6369@dastard>
References: <5141C1FC.4060209@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Dave Hall <kdhall@binghamton.edu>, stan@hardwarefreak.com

On Sonntag, 31. M=E4rz 2013 12:22:31 Dave Chinner wrote:
> On Fri, Mar 29, 2013 at 03:59:46PM -0400, Dave Hall wrote:
> > Dave, Stan,
> > =

> > Here is the link for perf top -U:  http://pastebin.com/JYLXYWki.
> > The ag report is at http://pastebin.com/VzziSa4L.  Interestingly,
> > the backups ran fast a couple times this week.  Once under 9 hours.
> > Today it looks like it's running long again.
> =

>     12.38%  [xfs]     [k] xfs_btree_get_rec
>     11.65%  [xfs]     [k] _xfs_buf_find
>     11.29%  [xfs]     [k] xfs_btree_increment
>      7.88%  [xfs]     [k] xfs_inobt_get_rec
>      5.40%  [kernel]  [k] intel_idle
>      4.13%  [xfs]     [k] xfs_btree_get_block
>      4.09%  [xfs]     [k] xfs_dialloc
>      3.21%  [xfs]     [k] xfs_btree_readahead
>      2.00%  [xfs]     [k] xfs_btree_rec_offset
>      1.50%  [xfs]     [k] xfs_btree_rec_addr
> =

> Inode allocation searches, looking for an inode near to the parent
> directory.
> =

> Whatthis indicates is that you have lots of sparsely allocated inode
> chunks on disk. i.e. each 64 indoe chunk has some free inodes in it,
> and some used inodes. This is Likely due to random removal of inodes
> as you delete old backups and link counts drop to zero. Because we
> only index inodes on "allocated chunks", finding a chunk that has a
> free inode can be like finding a needle in a haystack. There are
> heuristics used to stop searches from consuming too much CPU, but it
> still can be quite slow when you repeatedly hit those paths....
> =

> I don't have an answer that will magically speed things up for
> you right now...

Hmm, unfortunately, this access pattern is pretty common, at least all "cp =
-al =

& rsync" based backup solutions will suffer from it after a while. I notice=
d, =

that the "removing old backups" part is also taking *ages* in this scenario=
. =


I had to manually remove parts of a backup (subtrees with a few million =

ordinary files, massively hardlinked as usual), that took 4-5 hours for eac=
h =

run on a Hitachi Ultrastar 7K4000 drive. For the 8 subtrees, that finally t=
ook =

one and a half day, freeing about 500 GB space. Oh well.

The question is: is it (logically) possible to reorganize the fragmented in=
ode =

allocation space with a specialized tool (to be implemented), that lays out =

the allocation space in such a way, that matches XFS earliest "expectations=
", =

or does that violate some deeper FS logic, I'm not aware of? =


I have to mention, that I haven't made any tests with other file systems, a=
s =

playing games with backups ranges very low on my scale of sensible tests, b=
ut =

experience has shown, that XFS usually sucks less than its alternatives, ev=
en =

if the access pattern don't match its primary optimization domain.

Hence, implementing such a tool makes sense, where "least sucking" should b=
e =

aimed for.

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
