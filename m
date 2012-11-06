Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6MwvZX097125 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:58:58 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0WCbJmXOlyp92UNd for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 15:00:54 -0800 (PST)
Message-ID: <5099962C.9030404@redhat.com>
Date: Tue, 06 Nov 2012 17:58:52 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs_spaceman: updated preallocation support (eofblocks
	v6)
References: <1352213704-59959-1-git-send-email-bfoster@redhat.com>
	<20121106224337.GL24575@dastard>
In-Reply-To: <20121106224337.GL24575@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/06/2012 05:43 PM, Dave Chinner wrote:
> On Tue, Nov 06, 2012 at 09:55:04AM -0500, Brian Foster wrote:
>...
>> I can also squash this into the original and post a new version if that is
>> preferred. 
> 
> I'll probably do that myself - the current code I have is a little
> different so the patch probably won't apply, anyway.  I'll need to
> munge it to suit the eventual struct xfs_eofblocks format, anyway.
> 

Ok, I'll have a v2 replacement of this once the alignment thing is fixed
up...

> 
>> @@ -136,7 +142,7 @@ prealloc_help(void)
>>  "\n"
...
>> -	prealloc_cmd.argmin = 1;
>> +	prealloc_cmd.argmin = 0;
> 
> While technically correct, it's not the desired behaviour.  I wanted
> it to issue the usage if you just type the comment. I think I need
> to add a "-a" flag for "flush all" here.
> 

Ok.

>> -	prealloc_cmd.oneline = _("Control specualtive preallocation");
>> +	prealloc_cmd.oneline = _("Control speculative preallocation");
> 
> Good catch, Brain! :)
> 

Today a typo, tomorrow the world! ;)

Brain

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
