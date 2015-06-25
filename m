Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 321D17F78
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 17:58:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C08E2AC005
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 15:58:19 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SgvRQqGmxBfE16cz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 15:58:09 -0700 (PDT)
Date: Fri, 26 Jun 2015 00:58:07 +0200 (CEST)
From: Ales Novak <alnovak@suse.cz>
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
In-Reply-To: <557592E7.2010805@sgi.com>
Message-ID: <alpine.LSU.2.03.1506260054350.24061@suse.cz>
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard>
	<alpine.LSU.2.03.1506071054580.20732@suse.cz>
	<557592E7.2010805@sgi.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 2015-6-8 15:04, Mark Tinguely wrote:

> On 06/07/15 04:16, Ales Novak wrote:
>> 
>> On 2015-6-6 00:22, Dave Chinner wrote:
>> 
>>> Can you give more information about the crashes? From this
>>> description, I do not know whether this is a work around or a fix
>>> because I don't know what code is actually causing the problem or
>>> the circumstances in which the crash occurs. Hence I cannot
>>> determine if your change is the right change to make or whether the
>>> documetnation is simply wrong and we have a real bug we shoul dbe
>>> fixing.
>> 
>> The crashes occurred with logsunit=192k and logbsize=256k. xlog_sync()
>> is calculating in logsunit units:
>> 
>> count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
>> 
>> With count_init=256k, the calculated roundoff will try to cover that in
>> two 192k units. This roundoff is passed to the xlog_pack_data() which
>> walks the buffer and (hopefully) fails when it hits its 256k border.
>> 
>
> Talked about this once before:
>
> http://oss.sgi.com/archives/xfs/2013-03/msg00039.html
>
> Mark.
>

Thank you! I missed that.

Still I'd advocate for at least simple solution. Sure it's a root's fault 
if he tries to set logbsize not being integer multiple of logsunit, but 
crashing a kernel, that's bad...

-- 
Ales Novak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
