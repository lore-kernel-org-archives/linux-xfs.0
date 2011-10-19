Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JAmXN9179067 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 05:48:33 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D1491D9BB0
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:48:31 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id qYN6n2IrfJGGrZUH
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:48:31 -0700 (PDT)
Received: by bke11 with SMTP id 11so2121882bke.26
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:48:30 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,
	GET}FLAGS operations
In-Reply-To: <20111019092846.GA3083@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1316357699-22692-2-git-send-email-dmonakhov@openvz.org>
	<1317820840.2226.12.camel@doink> <87ty7m327v.fsf@dmbot.sw.ru>
	<20111019092846.GA3083@infradead.org>
Date: Wed, 19 Oct 2011 14:48:28 +0400
Message-ID: <874nz5xnnn.fsf@dmbot.sw.ru>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, aelder@sgi.com

On Wed, 19 Oct 2011 05:28:46 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Dmitry,
> 
> and updates on these patches?
I've posted new version here:
http://article.gmane.org/gmane.comp.file-systems.ext4/28602

Update for set flags patch now is named:
[PATCH 4/8] xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations

But still, ext4 panic in case of ordered+delalloc=>journalled switch
"-f setattr=1", i've not posted fix for that bug yet, so please run
this test carefully.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
