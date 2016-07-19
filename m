Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A4A37CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:24:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CAA88F8050
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 13:24:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JAhmgoYErDXFZb7e for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 13:24:34 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4D3474A4
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:24:34 -0500 (CDT)
Subject: Re: xfsdump quota failures
References: <578E78B0.2010602@ashurst.eu.org> <578E7988.6020102@ashurst.eu.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6eb6490f-0eb8-e488-8d71-ce86e5113f73@sandeen.net>
Date: Tue, 19 Jul 2016 13:24:33 -0700
MIME-Version: 1.0
In-Reply-To: <578E7988.6020102@ashurst.eu.org>
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

On 7/19/16 12:03 PM, Andy Bennett wrote:
> Hello again,
> 
> My Google-fu failed me before I posted but, of course, succeeded
> immediately after I hit send:
> 
> http://xfs.9218.n7.nabble.com/xfsdump-3-0-6-ERROR-xfs-quota-failed-with-exit-status-1-td30691.html
> 
> Does that mean that this error can be safely ignored in xfs_dump 3.0.6?

I believe so.  Can you confirm that quotas were correctly
restored?

-Eric
 
> 
> 
>> I'm running XFS for a few filesystems under a i686 Debian Linux VPS.
>>
>> Last night I upgraded from Debian Squeeze to Debian Wheezy. Before I
>> started the upgrade I took a backup using xfs_dump with my usual script
>> and everything went fine.
>>
>> Tonight I am trying to upgrade from Debian Wheezy to Debian Jessie so I
>> am taking another backup before I start.
>>
>> In the logs tonight I see the following errors for file systems that
>> have quotas enabled:
>>
>> -----
>> /usr/sbin/xfsdump: saving user quota information for: /home
>> /usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
>> /usr/sbin/xfsdump: ERROR: failed to save user quota information, continuing
>> /usr/sbin/xfsdump: saving group quota information for: /home
>> /usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
>> /usr/sbin/xfsdump: ERROR: failed to save group quota information, continuing
>> -----
>>
>> -----
>> /usr/sbin/xfsdump: saving user quota information for: /var
>> /usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
>> /usr/sbin/xfsdump: ERROR: failed to save user quota information, continuing
>> /usr/sbin/xfsdump: saving project quota information for: /var
>> /usr/sbin/xfsdump: ERROR: xfs_quota failed with exit status: -1
>> /usr/sbin/xfsdump: ERROR: failed to save project quota information,
>> continuing
>> -----
>>
>> One of the file systems has user and group quotas enabled and the other
>> has user and project quotas enabled.
>>
>> The root file system is XFS but does not have quotas enabled and it
>> dumps without error.
>>
>> When I run xfs_quota as root by hand it gives me an interactive prompt
>> and xfs_quota commands such as `df` and `print` seem to do what I would
>> expect without errors.
>>
>>
>> Both last night's dump and tonight's are level 0 dumps.
>>
>> Last night's dump used Debian Squeeze's xfsdump 3.0.4 with xfsprogs 3.1.4.
>> Tonight's dump uses Debian Wheezy's xfsdump 3.0.6 with xfsprogs 3.1.7.
>>
>>
>> Can anyone give me any guidance about what's going on and how to fix it?
>>
>>
>> Thanks for your help.
>>
>>
>>
>>
>> Regards,
>> @ndy
>>
> 
> 
> 
> 
> 
> Regards,
> @ndy
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
