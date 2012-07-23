Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NHmVKi195246 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 12:48:32 -0500
Received: from mail.amfes.com (wsip-24-120-114-53.lv.lv.cox.net
	[24.120.114.53]) by cuda.sgi.com with ESMTP id rVunzRtDRMUP7onO
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 10:48:25 -0700 (PDT)
Received: from mail.amfes.com (localhost [127.0.0.1])
	(using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by Postfix-ASSP.amfeslan.local (Postfix) with ESMTPSA id 2C8EE406B8EF
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 10:48:25 -0700 (PDT)
Message-ID: <assp.0551ab50e4.500D8E64.2040301@amfes.com>
Date: Mon, 23 Jul 2012 10:48:20 -0700
From: "Daniel L. Miller" <dmiller@amfes.com>
MIME-Version: 1.0
Subject: Re: Delay in folder access
References: <500CEF4B.8020400@amfes.com> <500D2731.5050004@hardwarefreak.com>
	<500D8D6C.8090707@amfes.com>
In-Reply-To: <500D8D6C.8090707@amfes.com>
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
To: xfs@oss.sgi.com

On 7/23/2012 10:44 AM, Daniel L. Miller wrote:
> On 7/23/2012 3:28 AM, Stan Hoeppner wrote:
>> On 7/23/2012 1:29 AM, Daniel L. Miller wrote:
>>> I have an XFS partition on simple 4-disk RAID-10 array.  The array is
>>> mounted at /raid.  I have a variety of subfolders - one of which is
>>> /raid/data - which in turn has a number of subfolders.
>>>
>>> Doing a simple "ls /raid" has no problems.  Similarly, no issues with
>>> "ls /raid/data/stuff".  But ... executing "ls /raid/data" results in a
>>> delay, sometimes in minutes, before it returns.
>> How many files are in /raid/data, excluding subdirs?  If it's many tens
>> of thousands ls will be slow, but I'd not think multiple minutes worth
>> of slow.
> 0 files, 7 subdirs, 1 symlink

I think I figured it out - and it has absolutely nothing to do with 
XFS.  That symlink?  It's to an autofs nfs mount - which doesn't exist.

Removing the symlink seems to have resolved the issue.
-- 
Daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
