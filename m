Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RISYCA216424 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:28:34 -0500
Received: from mx2.netapp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E63815144B5
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 11:28:45 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id UPxnL2vsSffRWVZH for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 11:28:45 -0700 (PDT)
Message-ID: <4E3058CF.9020304@netapp.com>
Date: Wed, 27 Jul 2011 14:28:31 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
MIME-Version: 1.0
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<4E303F6F.8010706@netapp.com> <201107271900.11091.sweet_f_a@gmx.de>
In-Reply-To: <201107271900.11091.sweet_f_a@gmx.de>
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
To: Ruediger Meier <sweet_f_a@gmx.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org

On 07/27/2011 01:00 PM, Ruediger Meier wrote:
> On Wednesday 27 July 2011, Bryan Schumaker wrote:
>> On 07/27/2011 12:28 PM, Justin Piszcz wrote:
>>> On Wed, 27 Jul 2011, J. Bruce Fields wrote:
>>>>
>>>> What filesystem on the server are you exporting?
>>>
>>> xfs.
>>> /dev/sda1 on / type xfs (rw,noatime)
>>>
>>> Nothing special, thoughts?
>>
>> Are there a lot of files in the directory you're exporting?  It looks
>> like cookie 10272 is mapped to multiple files.
> 
> I thought xfs is immune to readdir loops!?

I can ls a directory with 500,000 files over nfs4.  That's usually enough to cause the readdir loop in ext4, so I guess this is a different problem.

> Is your export directory really located directly within / on /dev/sda1?
> 
> cu,
> Rudi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
