Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9IU8TV136721 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 12:30:08 -0600
Message-ID: <509D4C28.9020307@sgi.com>
Date: Fri, 9 Nov 2012 12:32:08 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfsdump: refuse restore of V4 format unless FS has
	projid32bit set
References: <50788C50.40600@redhat.com> <50788EC3.2060701@sandeen.net>
In-Reply-To: <50788EC3.2060701@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/12/2012 04:42 PM, Eric Sandeen wrote:
> Restoring a dump w/ the top 16 bits of a 32-bit project ID
> set will fail to restore the full ID unless the projid32 feature
> flag is set on the filesystem.
>
> So if the target fs is xfs, fail the restore if we have a version
> 4 dump (only used currently if dumped from a projid32 fs) and
> the target xfs filesystem does not have that feature set.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> p.s. i'd rather go by whether the contents of the dump have any
>> 16 bit project ids than by the feature flag, but I don't see
> a way to do that.
>
> diff --git a/restore/content.c b/restore/content.c

Looks good Eric.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
