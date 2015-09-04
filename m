Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66FD47F6A
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 15:13:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4731930404E
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 13:13:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bP57yRup6S4YWi9E for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 13:13:49 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfs: create global stats and stats_clear in sysfs
References: <1441371319-31625-1-git-send-email-billodo@redhat.com>
	<1441371319-31625-2-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E9FB7D.2060502@sandeen.net>
Date: Fri, 4 Sep 2015 15:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <1441371319-31625-2-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>, xfs@oss.sgi.com

On 9/4/15 7:55 AM, Bill O'Donnell wrote:
> Currently, xfs global stats are in procfs. This patch introduces
> (replicates) the global stats in sysfs. Additionally a stats_clear file
> is introduced in sysfs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>


> +STATIC ssize_t
> +xfs_stats_store(
> +	struct kobject          *kobject,
> +	struct attribute        *attr,
> +	const char              *buf,
> +	size_t                  count)

still have some spaces after the types, before the vars...

Otherwise, this looks good to me; it's not the only place we have
missing tabs... *shrug* you could resend, or maybe Dave's willing
to fix up on commit.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
