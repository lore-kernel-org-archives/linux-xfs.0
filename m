Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF6A77F3F
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 15:23:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1DEF304043
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 13:23:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JCfKYXiKlkdPxvyI for
	<xfs@oss.sgi.com>; Fri, 09 May 2014 13:23:00 -0700 (PDT)
Message-ID: <536D3922.4080102@redhat.com>
Date: Fri, 09 May 2014 15:22:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: filter out selinux xattrs for generic/062
References: <1399664668-719-1-git-send-email-jbacik@fb.com>
	<536D37F6.90603@redhat.com> <536D38A6.9030107@fb.com>
In-Reply-To: <536D38A6.9030107@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 5/9/14, 3:20 PM, Josef Bacik wrote:
> I have MOUNT_OPTIONS set to something else so I lose the context bit. Thanks,

Seems like we need to add to them, then, not overwrite them, for selinux?

Otherwise I imagine many other tests will fail.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
