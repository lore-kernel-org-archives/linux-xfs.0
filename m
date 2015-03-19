Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D79197F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 12:27:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5AE78F804C
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:27:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iKMi98DkYop2VlJl for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 10:27:26 -0700 (PDT)
Message-ID: <550B06FE.4010603@sandeen.net>
Date: Thu, 19 Mar 2015 12:27:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 09/13] libxfs: remove ASSERT on ftype read from disk
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>	<1426624395-8258-10-git-send-email-sandeen@redhat.com>
	<20150319164643.GD11669@laptop.bfoster>
In-Reply-To: <20150319164643.GD11669@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 3/19/15 11:46 AM, Brian Foster wrote:

>> diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
>> index 89a1a21..695e698 100644
>> --- a/include/xfs_da_format.h
>> +++ b/include/xfs_da_format.h
>> @@ -561,7 +561,7 @@ xfs_dir3_dirent_get_ftype(
>>  	if (xfs_sb_version_hasftype(&mp->m_sb)) {
>>  		__uint8_t	type = dep->name[dep->namelen];
>>  
>> -		ASSERT(type < XFS_DIR3_FT_MAX);
>> +		//ASSERT(type < XFS_DIR3_FT_MAX);
> 
> Just delete it..?

Urgh.  yes.  I thought I had done so.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
