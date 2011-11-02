Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2KajjR198718 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 15:36:45 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0959421A3AC
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 13:36:44 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id WMMgg1hzfAZdf6XE
	for <xfs@oss.sgi.com>; Wed, 02 Nov 2011 13:36:44 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so630856bkb.26
	for <xfs@oss.sgi.com>; Wed, 02 Nov 2011 13:36:43 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 7/8] xfstests: add a new test that runs fsstress under
	ENOSPC conditions
In-Reply-To: <20111102195357.GA22500@infradead.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-8-git-send-email-dmonakhov@openvz.org>
	<20111102195357.GA22500@infradead.org>
Date: Thu, 03 Nov 2011 00:36:36 +0400
Message-ID: <8739e6z2gb.fsf@dmbot.sw.ru>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de, aelder@sgi.com

On Wed, 2 Nov 2011 15:53:58 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Oct 29, 2011 at 04:48:16AM +0400, Dmitry Monakhov wrote:
> > During stress testing we want to cover as much code paths as possible
> > fsstress is very good for this purpose. But it has expandable nature
> > (disk usage almost continually grow). So once it goes in no ENOSPC
> > condition it will be where till the end. But by running 'dd' writers
> > in parallel we can regularly trigger ENOSPC but only for a limited
> > periods of time because each time it opens the same file with O_TRUNC.
> 
> This fails for me on XFS because the fsstress process has already
> finished by the time you try to kill it:
> 
> --- 266.out	2011-11-02 19:46:27.000000000 +0000
> +++ 266.out.bad	2011-11-02 19:48:33.000000000 +0000
> @@ -3,3 +3,4 @@
>  Run fsstress
>   
>  Run dd writers in parallel
> +./266: line 60: kill: (3403) - No such process
Strange... this means that parent process died unexpectedly.
Works fine fore me. In my case this happen once due to unknown
options(new opt " -fsetattr=1" passed to fsstress explicitly) because i've
forget to rebuilt fsstress via make. Can you please explicitly rebuild,
and check one more time to be 100% sure.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevecalll" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
