Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D74C27F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 16:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 739A1AC005
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 14:27:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cQc94SgefY9QWQ6L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 14:27:02 -0700 (PDT)
Date: Thu, 24 Sep 2015 16:26:58 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 5/5] xfs: incorporate sysfs/kobject in xfsstats: handlers
	take kobjects.
Message-ID: <20150924212658.GA21293@redhat.com>
References: <1442923671-14125-1-git-send-email-billodo@redhat.com>
	<1442923671-14125-6-git-send-email-billodo@redhat.com>
	<56016A1E.8080103@sandeen.net> <20150922151605.GA29067@redhat.com>
	<20150922222636.GM19114@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150922222636.GM19114@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 08:26:36AM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2015 at 10:16:05AM -0500, Bill O'Donnell wrote:
> > > >  		goto out;
> > > >  
> > > >  	if (!proc_symlink("fs/xfs/stat", NULL,
> > > > -			  "/sys/fs/xfs/stats/stats"))
> > > > +			"/sys/fs/xfs/stats/stats"))
> > > 
> > > intentional whitespace changes?
> > > 
> > > >  		goto out_remove_xfs_dir;
> > > >  
> > > >  #ifdef CONFIG_XFS_QUOTA
> > > >  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
> > > > -			 &xqmstat_proc_fops))
> > > > +			&xqmstat_proc_fops))
> > > >  		goto out_remove_stat_file;
> > > >  	if (!proc_create("fs/xfs/xqm", 0, NULL,
> > > > -			 &xqm_proc_fops))
> > > > +			&xqm_proc_fops))
> > > 
> > > Same question.  (did checkpatch complain or something?)
> > 
> > Yes. Checkpatch didn't like any spaces, so I turned em into tabs.
> 
> Checkpatch should be considered harmful.
> 
> It's a good starting point, but it ends up doing more harm than good
> because it doesn't understand the subtle differences in code across
> different subsystems.
> 
> In this case, the standard we use for XFS is that multi-line
> parameters should be lined up with the first parameter, unless the
> new parameters don't fit on a single line, and then we back up the
> indent by a tab at a time. i.e. This is correct:
> 
> 	if (!proc_create("fs/xfs/xqm", 0, NULL,
> 			 &xqm_proc_fops))
> 
> regardless of what checkpatch says. Indeed, if checkpatch had any
> brains, it would have noticed that a line break is not necessary
> as this:
> 
> 	if (!proc_create("fs/xfs/xqm", 0, NULL, &xqm_proc_fops))
> 
> fits in 80 columns just fine.
> 
> Remember that Documentation/CodingStyle is a set of guidelines, not
> a strict, enforcable set of rules.  The basic guidelines canbe
> summarised as:
> 
> 	1. Use the same style as the existing code in the file,
> 	   unless reviewers/maintainers ask otherwise.
> 	2. new files should follow the format used in other files in
> 	   the subsystem, unless reviewers/maintainer asks otherwise.
> 	3. Do not reformat code that you don't need to directly
> 	   modify in the patch.
> 	4. modify your editor to highlight common style things that
> 	   you need reminders to get right
> 	5. Immolate checkpatch before the plague spreads further
> 
> As to #4, there's plenty of simple things you can do. e.g to
> identify stray whitespace in files, add this to your .vimrc file
> (you can do similar with emacs, google it):
> 
> 	" highlight whitespace damage
> 	highlight RedundantSpaces ctermbg=red guibg=red
> 	match RedundantSpaces /\s\+$\| \+\ze\t/
> 
> This will catch things like "tab-space-tab" and it will also find
> trailing whitespace at the end of lines. They will appear in red.
> 
> > > > -#define XFS_STATS_INC(v)	(per_cpu(xfsstats, current_cpu()).v++)
> > > > -#define XFS_STATS_DEC(v)	(per_cpu(xfsstats, current_cpu()).v--)
> > > > -#define XFS_STATS_ADD(v, inc)	(per_cpu(xfsstats, current_cpu()).v += (inc))
> > > > +#define XFS_STATS_INC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v++)
> > > > +#define XFS_STATS_DEC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v--)
> > > > +#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v += (inc))
> > > 
> > > Line > 80 chars
> > 
> > I'll fix it.
> 
> Checkpatch got changed not to warn about that, because too many
> people complained about it when modifying files with >80 column
> formatting.
> 
> To that end, I also use custom column width highlights based on file
> names so that line wrapping occurs automatically at the correct
> spot, and when looking at code I can clearly see long lines:
> 
> 	" set the textwidth to 80 characters by default
> 	set tw=80
> 
> 	" set the textwidth to 68 characters for guilt commit messages
> 	au BufNewFile,BufRead guilt.msg.*,.gitsendemail*,.git* set tw=68
> 
> 	" set the textwidth to 68 characters for replies (email&usenet)
> 	au BufNewFile,BufRead .letter,mutt*,nn.*,snd.* set tw=68
> 
> 	" highlight textwidth
> 	set cc=+1
> 
> If you do little things like this, the need for checkpatch goes
> away. With a default tw=80 and a highlight, I only have to glance
> at a patch to know it has lines longer than 80 columns in it.
> 
> As such, I haven't used checkpatch for years, and I recommend that
> you develop the right habits and automation such that you don't need
> to use it after a couple of months, either...

All points well taken. I'm fixing it all up in the next patch!

Thanks!
Bill

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
