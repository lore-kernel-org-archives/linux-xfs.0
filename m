Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3CEEM8007624 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 07:14:14 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 759481CDE7E3
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 05:14:12 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id ALQiYtx87AJ0grdl
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 05:14:12 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1257539bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 05:14:12 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
In-Reply-To: <87zkgdy2fi.fsf@dmbot.sw.ru>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
	<20111102195534.GB22500@infradead.org> <87zkgdy2fi.fsf@dmbot.sw.ru>
Date: Thu, 03 Nov 2011 16:14:04 +0400
Message-ID: <87ty6lxv1v.fsf@dmbot.sw.ru>
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

On Thu, 03 Nov 2011 13:34:41 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> On Wed, 2 Nov 2011 15:55:34 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> > On Sat, Oct 29, 2011 at 04:48:15AM +0400, Dmitry Monakhov wrote:
> > > Related bug: http://patchwork.ozlabs.org/patch/118863
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > This causes a very weird XFS failure in test 117 for me.  While it
> > obviously is an xfs bug that you uncovered (good!) I'm a bit worried
> > about simply enabling operations in existing tests.
> Ohh. i've got what your are talking about. We can not add new ops
> for tests there seed is passed explicitly. And yes i've braked this, but
> this is because such frozen tests was written in not determined
> way :). Good determined test should has not just seed opt, but also
> explicit set of operations. All others (non determined) tests which use
> fsstress may benefit from new ops. So I'll redo my patch queue like this:
> 1) Add explicit option set for all frozen tests
i've stuck immediately on first test ;(.
on my kernel 107'th test always failed (commit: 73a57c642cdfa660
"1.1.0 release"), is it expected? Which xfs-tree and commit should i use?
> 2) Add new features to fssstress with non zero probability. 
> > 
> > Alex, Eric, Dave - should we add new tests with the new operations
> > Dmitry added, or is adding new ops to the existing tests fine?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
