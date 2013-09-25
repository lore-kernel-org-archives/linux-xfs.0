Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FA5F7F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 16:34:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BA14AC002
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:34:05 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id 9zdPKLzx63hv6F6T
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:34:03 -0700 (PDT)
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:58238
	helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1) (envelope-from <lists@colorremedies.com>)
	id 1VOwig-004HsS-G1
	for xfs@oss.sgi.com; Wed, 25 Sep 2013 15:34:02 -0600
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: xfs hardware RAID alignment over linear lvm
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52435327.9080607@hardwarefreak.com>
Date: Wed, 25 Sep 2013 15:34:01 -0600
Message-Id: <2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Sep 25, 2013, at 3:18 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 9/25/2013 7:56 AM, Stewart Webb wrote:
>> Hi All,
> 
> Hi Stewart,
> 
>> I am trying to do the following:
>> 3 x Hardware RAID Cards each with a raid 6 volume of 12 disks presented to
>> the OS
>> all raid units have a "stripe size" of 512 KB
> 
> Just for future reference so you're using correct terminology, a value
> of 512KB is surely your XFS su value, also called a "strip" in LSI
> terminology, or a "chunk" in Linux software md/RAID terminology.  This
> is the amount of data written to each data spindle (excluding parity) in
> the array.
> 
> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
> amount of data written across the full RAID stripe (excluding parity).
> 
>> so given the info on the xfs.org wiki - I sould give each filesystem a
>> sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)
> 
> Partially correct.  If you format each /dev/[device] presented by the
> RAID controller with an XFS filesystem, 3 filesystems total, then your
> values above are correct.  EXCEPT you must use the su/sw parameters in
> mkfs.xfs if using BYTE values.  See mkfs.xfs(8)
> 
>> all well and good
>> 
>> But - I would like to use Linear LVM to bring all 3 cards into 1 logical
>> volume -
>> here is where my question crops up:
>> Does this effect how I need to align the filesystem?
> 
> In the case of a concatenation, which is what LVM linear is, you should
> use an XFS alignment identical to that for a single array as above.

So keeping the example, 3 arrays x 10 data disks, would this be su=512k and sw=30?


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
