Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C2777CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E30A68F8054
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 13:49:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Q15JymFHJPqTHMX2 for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 13:49:08 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4EC034A4
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:49:08 -0500 (CDT)
Subject: Re: xfsdump quota failures
References: <578E78B0.2010602@ashurst.eu.org> <578E7988.6020102@ashurst.eu.org>
	<6eb6490f-0eb8-e488-8d71-ce86e5113f73@sandeen.net>
	<578E9185.9080901@ashurst.eu.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c525945f-6156-331d-2553-e69b77909efb@sandeen.net>
Date: Tue, 19 Jul 2016 13:49:07 -0700
MIME-Version: 1.0
In-Reply-To: <578E9185.9080901@ashurst.eu.org>
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
To: xfs@oss.sgi.com


On 7/19/16 1:45 PM, Andy Bennett wrote:
> Hi,
> 
>>> My Google-fu failed me before I posted but, of course, succeeded
>>> immediately after I hit send:
>>>
>>> http://xfs.9218.n7.nabble.com/xfsdump-3-0-6-ERROR-xfs-quota-failed-with-exit-status-1-td30691.html
>>>
>>> Does that mean that this error can be safely ignored in xfs_dump 3.0.6?
>>
>> I believe so.  Can you confirm that quotas were correctly
>> restored?
> 
> Thanks!
> 
> How would I confirm that? I'm only taking a dump at this time and if I
> pipe the dump file into `xfsrestore -i` it doesn't say anything about
> quota or seem to have any commands to inspect them.

Sorry, got ahead of myself.  ;)  Forgot you were still at the dump
stage.

I guess you'd need to restore the dump to an xfs filesystem somewhere
and check whether the quotas are present as expected.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
