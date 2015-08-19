Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76C997F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 12:40:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45AE28F804C
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 10:40:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GkRkhylkw4GDIzNq for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 10:40:18 -0700 (PDT)
Message-ID: <55D4BF81.8090204@sandeen.net>
Date: Wed, 19 Aug 2015 12:40:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Fix uninitialized return value in
	xfs_alloc_fix_freelist()
References: <1436948168-25051-1-git-send-email-jack@suse.com>
	<20150715111649.GA60463@bfoster.bfoster>
In-Reply-To: <20150715111649.GA60463@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.com>
Cc: xfs@oss.sgi.com

On 7/15/15 6:16 AM, Brian Foster wrote:
> On Wed, Jul 15, 2015 at 10:16:08AM +0200, Jan Kara wrote:
>> xfs_alloc_fix_freelist() can sometimes jump to out_agbp_relse without
>> ever setting value of 'error' variable which is then returned. This can
>> happen e.g. when pag->pagf_init is set but AG is for metadata and we
>> want to allocate user data.
>>
>> Fix the problem by initializing 'error' to 0, which is the desired
>> return value when we decide to skip this group.
>>
>> CC: xfs@oss.sgi.com
>> Coverity-id: 1309714
>> Signed-off-by: Jan Kara <jack@suse.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Dave, ping on this one?  I don't see it in your latest update, looks important.
(xfsprogs has the same problem, FWIW)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
