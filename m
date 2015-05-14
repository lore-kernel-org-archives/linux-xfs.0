Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BE197F51
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 10:05:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D2BE8F8035
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 08:05:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d4us8u5Z2FImwyj2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 08:05:44 -0700 (PDT)
Message-ID: <5554B9C6.3010803@redhat.com>
Date: Thu, 14 May 2015 10:05:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: properly detect reserved attribute names
References: <555416A6.4020401@redhat.com>
	<20150514142210.GC23683@bfoster.bfoster>
In-Reply-To: <20150514142210.GC23683@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Zach Brown <zab@zabbo.net>, xfs-oss <xfs@oss.sgi.com>

On 5/14/15 9:22 AM, Brian Foster wrote:
> On Wed, May 13, 2015 at 10:29:42PM -0500, Eric Sandeen wrote:
>> This function in xfs_repair tries to make sure that if an attr
>> name reserved for acls exists in the root namespace, then its
>> value is a valid acl.
>>
>> However, because it only compares up to the length of the
>> reserved name, superstrings may match and cause false positive
>> xfs_repair errors.
>>
>> Ensure that both the length and the content match before
>> flagging it as an error.
>>
>> Spotted-by: Zach Brown <zab@zabbo.net>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> Looks good:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> So it looks like master doesn't have the sizeof(unsigned char *)
> problem and the 4.1 update branch does, so we want to make sure that
> kernel fix makes it into the latter...

Yep.  This fix is needed independently of that, though.

Thanks!
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
