Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C79758055
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 10:52:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1AC4304043
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 08:51:59 -0700 (PDT)
Received: from mail-yh0-f45.google.com (mail-yh0-f45.google.com
	[209.85.213.45]) by cuda.sgi.com with ESMTP id 9O0Ba5wFZZSTUjT8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 08:51:58 -0700 (PDT)
Received: by mail-yh0-f45.google.com with SMTP id a41so1044283yho.4
	for <xfs@oss.sgi.com>; Tue, 08 Apr 2014 08:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49bnwbyjyd.fsf@segfault.boston.devel.redhat.com>
References: <CAEH94LiJ6PBRRdFc4aZapLEPT7B7==0dUKQZqzQ6+vQpGpxHLg@mail.gmail.com>
	<x49bnwbyjyd.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 8 Apr 2014 23:51:58 +0800
Message-ID: <CAEH94LhG1nFpE1QhMzDP0aEhZj4M1J9Z=M-EM3rjSH6RaaDbNA@mail.gmail.com>
Subject: Re: [Bug] XFS: DIO random write + BufferIO read
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, jack@suse.cz, Theodore Ts'o <tytso@mit.edu>, xfstests <xfs@oss.sgi.com>

You can try the latest upstream.

On 4/8/14, Jeff Moyer <jmoyer@redhat.com> wrote:
> Zhi Yong Wu <zwu.kernel@gmail.com> writes:
>
>> HI
>>
>> When i try something on XFS filesytem, i hit one issue as below:
>>
>> One main task create multiple threads at first, Then it will dio
>> random write some files with random offset and length for each thread.
>> When those files get ready, those multiple threads will bufferio read
>> them and check if the data are same as their corresponding buffer. In
>> theory, they should be same, but the actual result isn't what we
>> expect
>>
>> By the way, i did the same try on ext3 filesystem, but didn't get any
>> such issue.
>
> What kernel version?
>
> Cheers,
> Jeff
>


-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
