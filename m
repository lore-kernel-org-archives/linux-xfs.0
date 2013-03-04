Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC8508051
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:12:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3976AC003
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 15:12:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	70mKm73WKUAW5Q71 for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 15:12:01 -0800 (PST)
Date: Tue, 5 Mar 2013 10:11:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfaults
Message-ID: <20130304231137.GN26081@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net> <20130301223116.GE23616@dastard>
	<51312C73.5060203@sandeen.net>
	<CANU9nT=ALsO3gegWP8vfmYO=CzgPPTRewAfZPYn_en-c2T8ayA@mail.gmail.com>
	<5134BB1F.4020207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5134BB1F.4020207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Ole Tange <tange@binf.ku.dk>

On Mon, Mar 04, 2013 at 09:17:51AM -0600, Eric Sandeen wrote:
> On 3/4/13 6:47 AM, Ole Tange wrote:
> > On Fri, Mar 1, 2013 at 11:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > 
> >> Ole, you can xfs_mdrestore your metadump image and run test repairs on the result,
> >> if you want a more realistic "dry run" of what repair would do.
> > 
> > I have never run xfs_mdrestore before.
> > 
> > From the man page:
> > 
> >        xfs_mdrestore should not be used to restore metadata onto an
> > existing filesystem unless you are completely certain the  target  can
> >  be destroyed.
> > 
> > It is unclear to me if you are suggesting me to do:
> > 
> >   xfs_mdrestore the-already-created-dump /dev/md5p1
> 
> no. definitely not. :)
> 
> > followed by xfs_repair. Or if you want me to restore the metadata on
> > another 100 TB partition (I do not have that available).
> 
> Nope - to a sparse file, on a filesystem which can hold a file with
> 100T offsets - like xfs.
> 
> > Maybe you have a trick so that it can be restored on some smaller
> > block device, so I do not need the 100 TB partition, but I will still
> > be able to see how many files are being removed? If you have such a
> > trick, consider including it in the manual.
> 
> Probably worth doing, or putting in the xfs faq.

Examples of how to do these sorts of operations should go into the
xfs users guide here:

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
