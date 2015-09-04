Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6C827F77
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 15:15:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B81A68F8040
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 13:15:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YbvrYusANChQCJxA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 13:15:54 -0700 (PDT)
Date: Fri, 4 Sep 2015 15:15:51 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 1/3] xfs: create global stats and stats_clear in sysfs
Message-ID: <20150904201551.GA20161@redhat.com>
References: <1441371319-31625-1-git-send-email-billodo@redhat.com>
	<1441371319-31625-2-git-send-email-billodo@redhat.com>
	<55E9FB7D.2060502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55E9FB7D.2060502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Sep 04, 2015 at 03:13:49PM -0500, Eric Sandeen wrote:
> On 9/4/15 7:55 AM, Bill O'Donnell wrote:
> > Currently, xfs global stats are in procfs. This patch introduces
> > (replicates) the global stats in sysfs. Additionally a stats_clear file
> > is introduced in sysfs.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> 
> > +STATIC ssize_t
> > +xfs_stats_store(
> > +	struct kobject          *kobject,
> > +	struct attribute        *attr,
> > +	const char              *buf,
> > +	size_t                  count)
> 
> still have some spaces after the types, before the vars...
> 
> Otherwise, this looks good to me; it's not the only place we have
> missing tabs... *shrug* you could resend, or maybe Dave's willing
> to fix up on commit.

Nah. I'll fix it and resubmit.
Thanks again for the review ;)
-Bill

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks,
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
