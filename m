Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66A147F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:31:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0425CAC004
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:31:09 -0700 (PDT)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id kGCi80NhH3Jga9u6 for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 12:31:08 -0700 (PDT)
Date: Tue, 15 Apr 2014 21:31:02 +0200 (CEST)
From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Message-ID: <1188577823.463241.1397590262478.JavaMail.zimbra@linbit.com>
In-Reply-To: <20140415175228.GE26404@infradead.org>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-2-git-send-email-bfoster@redhat.com>
	<20140410102421.GA17641@infradead.org>
	<20140410121947.GA14124@bfoster.bfoster>
	<20140410122944.GA6579@infradead.org>
	<20140415175228.GE26404@infradead.org>
Subject: Re: [PATCH v2 1/2] xfs: fix tmpfile/selinux deadlock and initialize
	security/acl
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-man@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Christoph,

On Tue, Apr 15, 2014 at 10:52:28AM -0700, Christoph Hellwig wrote:
> So any opinions from other fs / security people on how O_TMPFILE files
> should behave for ACL inheritance / labeling?

from how O_TMPFILE is documented right now [*], creating such a file and
then linking it into the namespace is one of the obvious use cases.  The
intent seems to be to make it seem like the file was created and populated
atomically, possibly with inherited permissions and all.  I think this
behavior require that the O_TMPFILE file inherits from the directory it
was "created" in.

Adding code to achieve the effect of create-time inheritance at link
time, only for O_TMPFILE files or files without any links, doesn't seem 
reasonable to me: it would duplicate create code in the link code path,
and it would make it harder to override inherited permissions or labels.

(Trying to fake inheritance by reimplementing it in user space seems like
a much worse idea still.)

[*] http://man7.org/linux/man-pages/man2/open.2.html

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
