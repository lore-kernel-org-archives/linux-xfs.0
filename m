Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09E2F7F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 16:57:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFF448F8049
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:57:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k4UuiaAMAzcP2fzW for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 14:57:16 -0700 (PDT)
Date: Thu, 26 Sep 2013 07:57:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs hardware RAID alignment over linear lvm
Message-ID: <20130925215713.GH26872@dastard>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 25, 2013 at 03:34:01PM -0600, Chris Murphy wrote:
> 
> On Sep 25, 2013, at 3:18 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> > On 9/25/2013 7:56 AM, Stewart Webb wrote:
> >> Hi All,
> > 
> > Hi Stewart,
> > 
> >> I am trying to do the following:
> >> 3 x Hardware RAID Cards each with a raid 6 volume of 12 disks presented to
> >> the OS
> >> all raid units have a "stripe size" of 512 KB
> > 
> > Just for future reference so you're using correct terminology, a value
> > of 512KB is surely your XFS su value, also called a "strip" in LSI
> > terminology, or a "chunk" in Linux software md/RAID terminology.  This
> > is the amount of data written to each data spindle (excluding parity) in
> > the array.
> > 
> > "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
> > amount of data written across the full RAID stripe (excluding parity).
> > 
> >> so given the info on the xfs.org wiki - I sould give each filesystem a
> >> sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)
> > 
> > Partially correct.  If you format each /dev/[device] presented by the
> > RAID controller with an XFS filesystem, 3 filesystems total, then your
> > values above are correct.  EXCEPT you must use the su/sw parameters in
> > mkfs.xfs if using BYTE values.  See mkfs.xfs(8)
> > 
> >> all well and good
> >> 
> >> But - I would like to use Linear LVM to bring all 3 cards into 1 logical
> >> volume -
> >> here is where my question crops up:
> >> Does this effect how I need to align the filesystem?
> > 
> > In the case of a concatenation, which is what LVM linear is, you should
> > use an XFS alignment identical to that for a single array as above.
                                                 ^^^^^^
> So keeping the example, 3 arrays x 10 data disks, would this be su=512k and sw=30?

No, the alignment should match that of a *single* 10 disk array,
so su=512k,sw=10.

Linear concatentation looks like this:

offset		volume				array
0		+-D1-+-D2-+.....+-Dn-+		0	# first sw
.....
X-sw		+-D1-+-D2-+.....+-Dn-+		0
X		+-E1-+-E2-+.....+-En-+		1	# first sw
.....
2X-sw		+-E1-+-E2-+.....+-En-+		1
2X		+-F1-+-F2-+.....+-Fn-+		2	# first sw
.....
3X-sw		+-F1-+-F2-+.....+-Fn-+		2

Where:
	D1...Dn are the disks in the first array
	E1...En are the disks in the second array
	F1...Fn are the disks in the third array
	X is the size of the each array
	sw = su * number of data disks in array

As you can see, all the volumes are arranged in a single column -
identical to a larger single array of the same size.  Hence the
exposed alignment of a single array is what the filesystem should be
aligned to, as that is how the linear concat behaves.

You also might note here that if you want the second and subsequent
arrays to be correctly aligned to the initial array in the linear
concat (and you do want that), the arrays must be sized to be an
exact multiple of the stripe width.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
