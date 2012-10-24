Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OKmb5T054320 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 15:48:37 -0500
Message-ID: <508854E9.7010809@sgi.com>
Date: Wed, 24 Oct 2012 15:51:53 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: Use upstream version of fstrim instead of
	the local one
References: <241834517.1979252.1349381614990.JavaMail.root@redhat.com>
In-Reply-To: <241834517.1979252.1349381614990.JavaMail.root@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, xfs@oss.sgi.com

Thomas,

On 10/04/2012 03:13 PM, Tomas Racek wrote:
> ----- Original Message -----
>> On Thu, 4 Oct 2012, Tomas Racek wrote:
>>

>> Ok, so the reason is to strip the variable mount point from the
>> error message. It sounds ok than.
>>
>> This makes me think that we maybe want to have a filter function to
>> filter out all the variables such as SCRATCH_MNT, SCRATCH_DEV,
>> TEST_DIR,
>> TEST_DEV and maybe more and replace then with the some appropriate
>> strings
>> (SCRATCH_MNT etc. maybe?). I am sure more tests can benefit from this
>> not
>> needing to to the filtering on their own.
>
> Oh, thanks for reminding me -- they already exist (see common.filter), I forgot about them. I will use them in next version. ;-)
>
>
> Tom
>


V4 has been committed to git://oss.sgi.com/xfs/cmds/xfstests, master branch.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
