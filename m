Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E55107F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:44:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A1C18F8049
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:44:44 -0700 (PDT)
Received: from mail-yh0-f49.google.com (mail-yh0-f49.google.com
	[209.85.213.49]) by cuda.sgi.com with ESMTP id C3ywhj5R0Rz2QkzM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:44:43 -0700 (PDT)
Received: by mail-yh0-f49.google.com with SMTP id f64so1144403yha.22
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:44:42 -0700 (PDT)
Message-ID: <51EEF949.9020104@gmail.com>
Date: Tue, 23 Jul 2013 17:44:41 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com>
In-Reply-To: <51EEF26F.5040001@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 07/23/2013 05:15 PM, Mark Tinguely wrote:
> On 07/19/13 01:25, Dave Chinner wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> Now that we have the size of the object before the formatting pass
>> is called, we can allocation the log vector and it's buffer in a
>> single allocation rather than two separate allocations.
>>
>> Store the size of the allocated buffer in the log vector so that
>> we potentially avoid allocation for future modifications of the
>> object.
>>
>> While touching this code, remove the IOP_FORMAT definition.
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> 
> Looks good.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

I'd like to register a gentle "test this well" protest on this patch. 
While trying to figure out the origin of an unrelated lockdep, I 
tried to copy 3 kernel gits from one 2k non-CRC XFS filesystem to 
another one.  With at least this patch used, the cp operation stops, 
leading to not-umountable, not-syncable filesystems.  It might be 
while copying the 2nd git, or the 3rd git, while copying header files, 
or while copying those large *.pack files, but it will happen 
somewhere.

A bisect of the issue ends on this patch, but its removal means that 
45_49 and 46_49 cannot be applied without good knowledge of the code 
to be patched.

This one's on me for not being able to get good information to Dave. 
If I can find a way to get trace-cmd to pipe over ssh or something 
like that, then maybe there's a chance to make a file that `trace-cmd 
report` can read.  Previous attempts to save to different filesystems 
or save over NFS and CIFS have all failed.  Will keep trying...

For diagnosing this patch, is there an effective trace that is rather 
small?  And would you need more than just the XFS events?

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
