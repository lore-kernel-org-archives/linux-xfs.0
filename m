Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38B3F7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:27:38 -0500 (CDT)
Date: Mon, 15 Jul 2013 16:27:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V4] xfstests: generic/314, test sgid inheritance on subdirs
Message-ID: <20130715212734.GA3572@sgi.com>
References: <1373658373-8988-1-git-send-email-cmaiolino@redhat.com>
	<51E2CEDE.5000304@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51E2CEDE.5000304@sandeen.net>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Sun, Jul 14, 2013 at 11:16:30AM -0500, Eric Sandeen wrote:
> On 7/12/13 2:46 PM, Carlos Maiolino wrote:
> > Tests if subdirectories created on the filesystem will properly inherit sgid bit
> > when this is set on the parent directory, once the process has the properly
> > permissions to create a subdirectory, this, should inherit parent's sgid bit if
> > this is set and irix_sgid_inherit sysctl is disabled.
> > 
> > V2: add missing source of "attr" file for _require_acls
> > 
> > V3: use _ls_l to filter out the selinux "."
> >     renumber to 314 to make the merge easier
> > 
> > V4: fix 314.out to the correct output
> 
> Heh, thanks Carlos.  Friday wasn't my best day.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
