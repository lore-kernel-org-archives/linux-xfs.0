Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B9107F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:59:58 -0500 (CDT)
Message-ID: <51961BE0.2080708@sgi.com>
Date: Fri, 17 May 2013 07:00:32 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 311: fsck the dmflakey device instead of the
	real device V2
References: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
	<5194E764.6030207@sgi.com>
	<20130516203035.GE1765@localhost.localdomain>
In-Reply-To: <20130516203035.GE1765@localhost.localdomain>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/16/2013 03:30 PM, Josef Bacik wrote:
> On Thu, May 16, 2013 at 08:04:20AM -0600, Rich Johnston wrote:
>> On 05/15/2013 10:20 AM, Josef Bacik wrote:
>>> Dave pointed out that xfs was having issues with 311 because of caching issues.
>>> He suggested that I fsck the dm-flakey device to make sure we don't have this
>>> problem.  Make _check_scratch_fs take an optional argument to use as the device
>>> to fsck.  Thanks,
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>> ---
>> Hi Josef,
>>
>> Looks like it fails test 19 , are we supposed to see failures for ext4
>> and xfs?
>>
>
> Yeah that's what I was seeing, if you run the fsync tester without the reboot
> option and look at the file itself it should match the md5sum thats in the good
> output.  Thanks,
>
> Josef
>
Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
