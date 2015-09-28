Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 349827F37
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:00:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 231C48F8052
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 08:00:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uiYC6MehXuV8AhET for <xfs@oss.sgi.com>;
	Mon, 28 Sep 2015 08:00:45 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 23D6E6BAE239
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 10:00:45 -0500 (CDT)
Subject: Re: [PATCH 0/7 v8] xfs: stats in sysfs
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5609561C.5040508@sandeen.net>
Date: Mon, 28 Sep 2015 10:00:44 -0500
MIME-Version: 1.0
In-Reply-To: <1443223380-18870-1-git-send-email-billodo@redhat.com>
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
To: xfs@oss.sgi.com

On 9/25/15 6:22 PM, Bill O'Donnell wrote:
> 
> Hello-
> 
> Following is the next iteration of the series to add xfs stats to
> sysfs. This iteration adds patches 6 and 7 to complete the incorporation
> of sysfs/kobject into xfsstats, including working global and per-fs stats.

Hi Bill - as I mentioned on IRC, it looks like a lot of the patches in this
series fix up review comments for *prior* patches; i.e. Patch X implements
a change X, and got review comments when originally submitted.

Then Patch Y introduces change Y, but also fixes up comments in Patch X.

When you get review comments, they really need to be fixed up in that
patch, not later in the patch series.  This is for two reasons; for one,
we really want each committed patch to be correct stylistically and 
functionally.  And two, it simplifies review of the series; one doesn't
need to look forward in the series to find fixes for prior patches, and
each patch contains only its own functional changes, not unrelated fixups
for prior patches.

So for example, if you have a patch which is fixing whitespace on code
introduced in a previous patch, it's in the wrong patch.

Or for a more concrete example, in patch 5 you do:

 for_each_possible_cpu(cpu)
-		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
+		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));
 return val;

and then in patch 6 you do:

 	for_each_possible_cpu(cpu)
-		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));

 	return val;

But this is unrelated to the purpose of patch 6; it should just be fixed
up in a modified patch 5, i.e.

 	for_each_possible_cpu(cpu)
-		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
+		val += *(((__u32 *)per_cpu_ptr(stats, cpu) + idx));
	return val;

So I'll restrict review comments to the actual end product, rather than
patch by patch, because it's tough to review patch X when it has issues
whichi are fixed up by patch X+1 or X+2 or ...  :)

If you have any questions about all this, please let me know.

Thanks,
-Eric


 
> ----------history---------------
> v8: (add patches 6 and 7)
> -patch 6: per-filesystem stats in sysfs.
> Implement per-filesystem stats objects in sysfs. Stats objects are
> instantiated when an xfs filesystem is mounted and deleted on unmount.
> With this patch, the stats directory is created and populated with
> the familiar stats and stats_clear files.
>     Example:
>             /sys/fs/xfs/sda9/stats/stats
>             /sys/fs/xfs/sda9/stats/stats_clear
> 
> With this patch, the individual counts within the new per-fs
> stats file(s) remain at zero. Functions that use the the macros
> to increment, decrement, and add-to the per-fs stats counts will
> be covered in the next patch (7).
> 
> Also, this patch includes some minor fixups for style issues in
> patch 5.
> 
> 
> -patch 7: per-filesystem stats counter implementation
> Modify the stats counting macros and the callers
> to those macros to properly increment, decrement, and add-to
> the xfs stats counts. The counts for global and per-fs stats
> are correctly advanced, and cleared by writing a "1" to the
> corresponding clear file.
> 
> global counts: /sys/fs/xfs/stats/stats
> per-fs counts: /sys/fs/xfs/sda*/stats/stats
> 
> global clear:  /sys/fs/xfs/stats/stats_clear
> per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear
> 
> 
> v7:
> add patch 5/5: incorporate sysfs/kobject in xfsstats: handlers
> take kobjects. Allocate & deallocate per-fs stats structures
> and set up the sysfs entries for them. Add kobject and a pointer
> to a per-cpu struct xfsstats. Modify the macros that manipulate
> the stats accordingly.
> 
> v6:
> -add patch 4/4: move to_xlog(kobject) to the relevant show/store
> operations. This keeps the xfs_sysfs_object_show/store functions
> generic. Also, with the change, there can be some cleanup of the
> show/store function arguments.
> 
> v5:
> -optimization of sysfs_ops function.
> -style fixups
> 
> v4:
> -whitespace fixup of patch 1
> -add patch 4 (sysfs ops consolidation - dbg, stats, log)
> 
> v3:
> -style fixups and removal of extraneous printk.
> 
> v2:
> -style fixups.
> v1:
> --------------------------------
> 
> We already have per-fs information in /sys, so it makes sense to
> have per-fs stats there too.  The series moves existing
> global stats infrastructure to /sys and reuses that code to
> create per-fs stats in /sys.
> 
> Patch 1 handles the bring-up and tear down of xfs/stats directory
> structure in sysfs when an fs is mounted. The directory contains
> the stats file and the stats_clear file. The stats file contents mimic
> those of /proc/fs/xfs/stat. The stats_clear file is empty, and much
> like the current stat_clear command, handles the zeroing of the stats
> file when a "1" is echoed to the stats_clear file.
> 
> Patch 2 creates the symlink for stats from procfs to sysfs.
> 
> Patch 3 removes the now unused portions of procfs for stat.
> 
> Patch 4 consolidates the sysfs ops for dbg, stats, log.
> 
> Patch 5 allocates and deallocates per-fs stats structures and
> sets up the sysfs entries for them. Add kobject and a pointer
> to a per-cpu struct xfsstats. Modify the macros that manipulate
> the stats accordingly.
> 
> Patch 6 implements per-filesystem stats objects in sysfs. Stats
> objects are instantiated when an xfs filesystem is mounted and
> deleted on unmount.
> 
> Patch 7 modifies the stats counting macros and the callers
> to those macros to properly increment, decrement, and add-to
> the xfs stats counts. The counts for global and per-fs stats
> are correctly advanced, and cleared by writing a "1" to the
> corresponding clear file.
> 
> Once again, comments and questions are welcome.
> 
> Thanks-
> Bill
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
