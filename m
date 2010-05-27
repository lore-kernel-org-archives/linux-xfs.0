Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RHX01l149667 for <xfs@oss.sgi.com>; Thu, 27 May 2010 12:33:00 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87982149D589
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 10:37:15 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 3APsRGIWP72zRfzs for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 10:37:15 -0700 (PDT)
Date: Thu, 27 May 2010 19:35:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] xfstests-dev: More stress tests
Message-ID: <20100527173508.GD3576@quack.suse.cz>
References: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274977524-19741-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: hch@infradead.org, sandeen@redhat.com, jack@suse.cz, xfs@oss.sgi.com

On Thu 27-05-10 20:25:22, Dmitry Monakhov wrote:
> I've finally port my tests to common platform with respect to previous
> comments. Pathes agains Jen's xfstest tree
> 
> *Tests state*
> I've executed it on ext4 on current ext4.git/next snapshot and
> with http://patchwork.ozlabs.org/patch/53720/
> 
> 0001) Is now succeed finally.(i've found more than 5 bugs with that testcase)
> 
> 0002) Is failed by now:
>       Sometimes it failed due to quota leak (dont know where yet)
  I sometimes observe that quota accounting is wrong on ext4 in my fsstress
test as well...

>       Sometimes kernel hungs with following call trace:
>       sys_quotactl
>       ->do_quotactl
>         ->vfs_quota_off
>           ->vfs_quota_disable
>             ->invalidate_dquots()
>               /* Wait here for a dqput */
>      Seems what we have dquot leakage.
> Still digging...
  Hmm, interesting. I don't have a clue where that could happen.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
