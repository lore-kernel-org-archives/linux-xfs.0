Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 076287F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 16:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9DA18F8049
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:53:27 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id E3jPyNI0AHft5VSp
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:53:26 -0700 (PDT)
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:58444
	helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1) (envelope-from <lists@colorremedies.com>)
	id 1VOx1R-0001bk-PL
	for xfs@oss.sgi.com; Wed, 25 Sep 2013 15:53:25 -0600
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: xfs hardware RAID alignment over linear lvm
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52435A1B.8040207@hardwarefreak.com>
Date: Wed, 25 Sep 2013 15:53:24 -0600
Message-Id: <56657F55-C39E-41D8-8BED-AA2C27C26B61@colorremedies.com>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<52435A1B.8040207@hardwarefreak.com>
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


On Sep 25, 2013, at 3:48 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> 
>> So keeping the example, 3 arrays x 10 data disks, would this be su=512k and sw=30?
> 
> No.  In this configuration, as far as XFS is concerned LVM doesn't exist
> in the stack because it doesn't change the RAID geometry, so you ignore it.

OK and if this were md linear where the file system definitely would be created across all disks?


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
