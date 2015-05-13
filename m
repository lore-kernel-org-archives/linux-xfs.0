Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D87877F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 17:42:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC101304032
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 15:42:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DmLO2h1DJBdonMh3 for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 15:42:44 -0700 (PDT)
Message-ID: <5553D362.501@sandeen.net>
Date: Wed, 13 May 2015 17:42:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
References: <20150511000508.GD16689@dastard> <5553CCD2.1010906@sandeen.net>
	<5553CF6D.9080501@sandeen.net>
In-Reply-To: <5553CF6D.9080501@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 5/13/15 5:25 PM, Eric Sandeen wrote:
> On 5/13/15 5:14 PM, Eric Sandeen wrote:
>> One interesting problem that arises from this is in xfs_format.h:
>>
>> /* On-disk XFS extended attribute names */
>> #define SGI_ACL_FILE            (char *)"SGI_ACL_FILE"
>> #define SGI_ACL_DEFAULT         (char *)"SGI_ACL_DEFAULT"
>> #define SGI_ACL_FILE_SIZE       (sizeof(SGI_ACL_FILE)-1)
>> #define SGI_ACL_DEFAULT_SIZE    (sizeof(SGI_ACL_DEFAULT)-1)
>>
>> (aside: why is it unsigned in the kernel but not here?)
>>
>> Anyway: that "sizeof" gives us 7, because it's getting the
>> size of the pointer, not the string literal.  Cool eh!
>> Never mattered in the kernel, because the _SIZE macros aren't
>> used.
>>
>> I'm not actually sure what the cleanest way to fix this is;
>> casting string literals gets way past my comfort level with
>> C pedantry; technically if we want an array of unsigned chars,
>> we probably need:
>>
>> unsigned char *SGI_ACL_FILE[] = "SGI_ACL_FILE";
>> unsigned char *SGI_ACL_DEFAULT[] = "SGI_ACL_DEFAULT";
> 
> Er, drop the * of course ...

I think we can just drop the ([unsigned] char *) bit and move on,
assigning the string literal to an unsigned char * should be fine.
Right?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
