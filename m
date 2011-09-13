Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DJVbBD078566 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 14:31:37 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E7FD15AFD5
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 12:31:35 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id AHzRUI9dSj2tSjc3
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 12:31:35 -0700 (PDT)
Message-ID: <4E6FAF81.6060904@profihost.ag>
Date: Tue, 13 Sep 2011 21:31:13 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
In-Reply-To: <4E6EF274.7050007@profihost.ag>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am 13.09.2011 08:04, schrieb Stefan Priebe - Profihost AG:
> Hi,
>
>> On Mon, Sep 12, 2011 at 06:46:26PM +0200, Stefan Priebe wrote:
>>>> What kind of workload are you running? Also did the workload run fine
>>>> with an older kernel, and if yes which one?
>>>
>>> Mysql, Web, Mail, ftp ;-) yes it was with 2.6.32. I upgraded from
>>> that version.
>>
>> Just curious, is this the same system that also shows the freezes
>> reported to the scsi list? If I/Os don't get completed by lower layers
>> I can see how we get everything in XFS waiting on the log reservations,
>> given that we never get the log tail pushed.
>
> I just reported it to the scsi list as i didn't knew where the problems
> is. But then some people told be it must be a XFS problem.
>
> Some more informations:
> 1.) It's running with 2.6.32 and 2.6.38
> 2.) I can also write to another ext2 part on the same disk array(aacraid
> driver) while xfs stucks - so i think it must be an xfs problem
> 3.) I've also tried running 3.1-rc5 but then i'm seeing this error:
>
 > ...
>

Any idea what we could try next or how to find the problem? At least 
this is happening with different devices and writing to other partitions 
is still working.

Greets
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
