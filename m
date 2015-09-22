Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4DCF47F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 10:16:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFC46AC005
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:16:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dsIOcbfdzt31hO1T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:16:09 -0700 (PDT)
Date: Tue, 22 Sep 2015 10:16:05 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 5/5] xfs: incorporate sysfs/kobject in xfsstats: handlers
	take kobjects.
Message-ID: <20150922151605.GA29067@redhat.com>
References: <1442923671-14125-1-git-send-email-billodo@redhat.com>
	<1442923671-14125-6-git-send-email-billodo@redhat.com>
	<56016A1E.8080103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56016A1E.8080103@sandeen.net>
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

Thanks for the review, Eric.


On Tue, Sep 22, 2015 at 09:47:58AM -0500, Eric Sandeen wrote:
> On 9/22/15 7:07 AM, Bill O'Donnell wrote:
> > This patch is the next step toward per-fs xfs stats. Allocate &
> > deallocate per-fs stats structures and set up the sysfs entries for them.
> 
> Ok, the patch doesn't actually do that last sentence yet, so
> I'd leave it out of the description.  :)

Agreed.

> 
> You could mumble about how this enables the next patch, though, i.e.
> this makes the show & clear routines able to handle any stats structure
> associated with a kobject.

Yep.

> 
> > Instead of a single global xfsstats structure, add kobject and a pointer
> > to a per-cpu struct xfsstats. Modify the macros that manipulate the stats
> > accordingly: XFS_STATS_INC, XFS_STATS_DEC, and XFS_STATS_ADD now access
> > xfsstats->xs_stats.
> > 
> > The sysfs functions need to get from the kobject back to the xfsstats
> > structure which contains it, and pass the pointer to the ->xs_stats
> > percpu structure into the show & clear routines.
> > 
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/xfs_linux.h  |  7 +++++++
> >  fs/xfs/xfs_stats.c  | 47 ++++++++++++++++++++++++-----------------------
> >  fs/xfs/xfs_stats.h  | 13 ++++++-------
> >  fs/xfs/xfs_super.c  | 15 ++++++++-------
> >  fs/xfs/xfs_sysctl.c |  2 +-
> >  fs/xfs/xfs_sysfs.c  | 17 +++++++++++++++--
> >  6 files changed, 61 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > index 85f883d..f1a8505 100644
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -171,6 +171,13 @@ struct xfs_kobj {
> >  	struct completion	complete;
> >  };
> >  
> > +struct xstats {
> > +	struct xfsstats __percpu *xs_stats;
> > +	struct xfs_kobj         xs_kobj;
> 
> nitpick, I'd fiddle w/ whitespace a little to make the 2 members line
> up nicely.

Ok

> 
> > +};
> > +
> > +extern struct xstats xfsstats;
> > +
> >  /* Kernel uid/gid conversion. These are used to convert to/from the on disk
> >   * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
> >   * The conversion here is type only, the value will remain the same since we
> > diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> > index dc6ca67..ab79973 100644
> > --- a/fs/xfs/xfs_stats.c
> > +++ b/fs/xfs/xfs_stats.c
> > @@ -18,18 +18,18 @@
> >  #include "xfs.h"
> >  #include <linux/proc_fs.h>
> >  
> > -DEFINE_PER_CPU(struct xfsstats, xfsstats);
> > +struct xstats xfsstats;
> >  
> > -static int counter_val(int idx)
> > +static int counter_val(struct xfsstats __percpu *stats, int idx)
> >  {
> >  	int val = 0, cpu;
> >  
> >  	for_each_possible_cpu(cpu)
> > -		val += *(((__u32 *)&per_cpu(xfsstats, cpu) + idx));
> > +		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));
> 
> Now that we are referring to a pointer to a percpu structure
> (instead of the old global xfsstats structure itself), I think it's
> a lot cleaner & more legible to do:
> 
> +		val += *(((__u32 *)per_cpu_ptr(stats, cpu) + idx));
> 
> (ok the cast gyrations may not qualify as "clean and legible" but it
> helps - see also below)

Agreed.

> 
> >  	return val;
> >  }
> >  
> > -int xfs_stats_format(char *buf)
> > +int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
> >  {
> >  	int		i, j;
> >  	int		len = 0;
> > @@ -73,14 +73,14 @@ int xfs_stats_format(char *buf)
> >  		/* inner loop does each group */
> >  		for (; j < xstats[i].endpoint; j++)
> >  			len += snprintf(buf + len, PATH_MAX - len, " %u",
> > -					counter_val(j));
> > +					counter_val(stats, j));
> >  		len += snprintf(buf + len, PATH_MAX - len, "\n");
> >  	}
> >  	/* extra precision counters */
> >  	for_each_possible_cpu(i) {
> > -		xs_xstrat_bytes += per_cpu(xfsstats, i).xs_xstrat_bytes;
> > -		xs_write_bytes += per_cpu(xfsstats, i).xs_write_bytes;
> > -		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
> > +		xs_xstrat_bytes += per_cpu(*stats, i).xs_xstrat_bytes;
> > +		xs_write_bytes += per_cpu(*stats, i).xs_write_bytes;
> > +		xs_read_bytes += per_cpu(*stats, i).xs_read_bytes;
> 
> ditto here,
> 
> +		xs_xstrat_bytes += per_cpu_ptr(stats, i)->xs_xstrat_bytes;
> +		xs_write_bytes += per_cpu_ptr(stats, i)->xs_write_bytes;
> +		xs_read_bytes += per_cpu_ptr(stats, i)->xs_read_bytes;
> 
> >  	}
> >  
> >  	len += snprintf(buf+len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
> > @@ -95,7 +95,7 @@ int xfs_stats_format(char *buf)
> >  	return len;
> >  }
> >  
> > -void xfs_stats_clearall(void)
> > +void xfs_stats_clearall(struct xfsstats __percpu *stats)
> >  {
> >  	int		c;
> >  	__uint32_t	vn_active;
> > @@ -104,10 +104,10 @@ void xfs_stats_clearall(void)
> >  	for_each_possible_cpu(c) {
> >  		preempt_disable();
> >  		/* save vn_active, it's a universal truth! */
> > -		vn_active = per_cpu(xfsstats, c).vn_active;
> > -		memset(&per_cpu(xfsstats, c), 0,
> > -		       sizeof(struct xfsstats));
> > -		per_cpu(xfsstats, c).vn_active = vn_active;
> > +		vn_active = per_cpu(*stats, c).vn_active;
> > +		memset(&per_cpu(*stats, c), 0,
> > +		       sizeof(*stats));
> > +		per_cpu(*stats, c).vn_active = vn_active;
> >  		preempt_enable();
> >  	}
> >  }
> 
> 
> +		vn_active = per_cpu_ptr(stats, c)->vn_active;
> +		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
> +		per_cpu_ptr(stats, c)->vn_active = vn_active;
> 
> 
> > @@ -119,9 +119,10 @@ static int xqm_proc_show(struct seq_file *m, void *v)
> >  	/* maximum; incore; ratio free to inuse; freelist */
> >  	seq_printf(m, "%d\t%d\t%d\t%u\n",
> >  			0,
> > -			counter_val(XFSSTAT_END_XQMSTAT),
> > +			counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
> >  			0,
> > -			counter_val(XFSSTAT_END_XQMSTAT + 1));
> > +			counter_val(xfsstats.xs_stats,
> > +				XFSSTAT_END_XQMSTAT + 1));
> 
> might be able to make this fit on one line by lining up the "0"
> with the "%d" but *shrug* now i'm really being stupidly nitpicky.

;)

> 
> >  	return 0;
> >  }
> >  
> > @@ -145,7 +146,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
> >  
> >  	seq_printf(m, "qm");
> >  	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
> > -		seq_printf(m, " %u", counter_val(j));
> > +		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
> >  	seq_putc(m, '\n');
> >  	return 0;
> >  }
> > @@ -171,28 +172,28 @@ xfs_init_procfs(void)
> >  		goto out;
> >  
> >  	if (!proc_symlink("fs/xfs/stat", NULL,
> > -			  "/sys/fs/xfs/stats/stats"))
> > +			"/sys/fs/xfs/stats/stats"))
> 
> intentional whitespace changes?
> 
> >  		goto out_remove_xfs_dir;
> >  
> >  #ifdef CONFIG_XFS_QUOTA
> >  	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
> > -			 &xqmstat_proc_fops))
> > +			&xqmstat_proc_fops))
> >  		goto out_remove_stat_file;
> >  	if (!proc_create("fs/xfs/xqm", 0, NULL,
> > -			 &xqm_proc_fops))
> > +			&xqm_proc_fops))
> 
> Same question.  (did checkpatch complain or something?)

Yes. Checkpatch didn't like any spaces, so I turned em into tabs.

> 
> >  		goto out_remove_xqmstat_file;
> >  #endif
> >  	return 0;
> >  
> >  #ifdef CONFIG_XFS_QUOTA
> > - out_remove_xqmstat_file:
> > +out_remove_xqmstat_file:
> >  	remove_proc_entry("fs/xfs/xqmstat", NULL);
> > - out_remove_stat_file:
> > +out_remove_stat_file:
> >  	remove_proc_entry("fs/xfs/stat", NULL);
> >  #endif
> > - out_remove_xfs_dir:
> > +out_remove_xfs_dir:
> >  	remove_proc_entry("fs/xfs", NULL);
> > - out:
> > +out:
> >  	return -ENOMEM;
> >  }
> 
> same whitespace question.  unless there's a reason, I'd not include
> these nonfunctional changes in this patch.

Again, checkpatch didn't care for the preceding space on out_blah...

> 
> > diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> > index 18807b5..672fe83 100644
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -18,9 +18,6 @@
> >  #ifndef __XFS_STATS_H__
> >  #define __XFS_STATS_H__
> >  
> > -int xfs_stats_format(char *buf);
> > -void xfs_stats_clearall(void);
> > -
> >  #if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
> >  
> >  #include <linux/percpu.h>
> > @@ -217,15 +214,17 @@ struct xfsstats {
> >  	__uint64_t		xs_read_bytes;
> >  };
> >  
> > -DECLARE_PER_CPU(struct xfsstats, xfsstats);
> > +int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
> > +void xfs_stats_clearall(struct xfsstats __percpu *stats);
> > +extern struct xstats xfsstats;
> >  
> >  /*
> >   * We don't disable preempt, not too worried about poking the
> >   * wrong CPU's stat for now (also aggregated before reporting).
> >   */
> > -#define XFS_STATS_INC(v)	(per_cpu(xfsstats, current_cpu()).v++)
> > -#define XFS_STATS_DEC(v)	(per_cpu(xfsstats, current_cpu()).v--)
> > -#define XFS_STATS_ADD(v, inc)	(per_cpu(xfsstats, current_cpu()).v += (inc))
> > +#define XFS_STATS_INC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v++)
> > +#define XFS_STATS_DEC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v--)
> > +#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v += (inc))
> 
> Line > 80 chars

I'll fix it.

> 
> >  
> >  extern int xfs_init_procfs(void);
> >  extern void xfs_cleanup_procfs(void);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 31ad281..f1ea1c9 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -61,7 +61,6 @@ static kmem_zone_t *xfs_ioend_zone;
> >  mempool_t *xfs_ioend_pool;
> >  
> >  static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> > -static struct xfs_kobj xfs_stats_kobj;	/* global stats sysfs attrs */
> >  #ifdef DEBUG
> >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
> >  #endif
> > @@ -1802,6 +1801,7 @@ xfs_destroy_workqueues(void)
> >  	destroy_workqueue(xfs_alloc_wq);
> >  }
> >  
> > +
> 
> no need for a new newline here
> 
> >  STATIC int __init
> >  init_xfs_fs(void)
> >  {
> > @@ -1842,8 +1842,9 @@ init_xfs_fs(void)
> >  		goto out_sysctl_unregister;
> >  	}
> >  
> > -	xfs_stats_kobj.kobject.kset = xfs_kset;
> > -	error = xfs_sysfs_init(&xfs_stats_kobj, &xfs_stats_ktype, NULL,
> > +	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
> 
> 
> need to check for allocation failure here, and fix up the goto/cleanup
> targets as a result.

Will do.

> 
> > +	xfsstats.xs_kobj.kobject.kset = xfs_kset;
> > +	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
> >  			       "stats");
> >  	if (error)
> >  		goto out_kset_unregister;
> > @@ -1852,7 +1853,7 @@ init_xfs_fs(void)
> >  	xfs_dbg_kobj.kobject.kset = xfs_kset;
> >  	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
> >  	if (error)
> > -		goto out_remove_stats_kobj;
> > +		goto out_remove_stats;
> >  #endif
> >  
> >  	error = xfs_qm_init();
> > @@ -1869,9 +1870,9 @@ init_xfs_fs(void)
> >   out_remove_dbg_kobj:
> >  #ifdef DEBUG
> >  	xfs_sysfs_del(&xfs_dbg_kobj);
> > - out_remove_stats_kobj:
> > + out_remove_stats:
> >  #endif
> > -	xfs_sysfs_del(&xfs_stats_kobj);
> > +	free_percpu(xfsstats.xs_stats);
> >   out_kset_unregister:
> >  	kset_unregister(xfs_kset);
> >   out_sysctl_unregister:
> > @@ -1898,7 +1899,7 @@ exit_xfs_fs(void)
> >  #ifdef DEBUG
> >  	xfs_sysfs_del(&xfs_dbg_kobj);
> >  #endif
> > -	xfs_sysfs_del(&xfs_stats_kobj);
> > +	free_percpu(xfsstats.xs_stats);
> 
> still need to delete the sysfs entry, even though it's no longer
> the xfs_stats_kobj - now it's the xfsstats.xs_kobj right?

Correct.

> 
> >  	kset_unregister(xfs_kset);
> >  	xfs_sysctl_unregister();
> >  	xfs_cleanup_procfs();
> > diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> > index 5defabb..aed74d3 100644
> > --- a/fs/xfs/xfs_sysctl.c
> > +++ b/fs/xfs/xfs_sysctl.c
> > @@ -37,7 +37,7 @@ xfs_stats_clear_proc_handler(
> >  	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> >  
> >  	if (!ret && write && *valp) {
> > -		xfs_stats_clearall();
> > +		xfs_stats_clearall(xfsstats.xs_stats);
> >  		xfs_stats_clear = 0;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index ab4850b..3275408 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -131,12 +131,23 @@ struct kobj_type xfs_dbg_ktype = {
> >  
> >  /* stats */
> >  
> > +static inline struct xstats *
> > +to_xstats(struct kobject *kobject)
> > +{
> > +	struct xfs_kobj *kobj = to_kobj(kobject);
> > +
> > +	return container_of(kobj, struct xstats, xs_kobj);
> > +}
> > +
> > +
> >  STATIC ssize_t
> >  stats_show(
> >  	struct kobject	*kobject,
> >  	char	*buf)
> >  {
> > -	return xfs_stats_format(buf);
> > +	struct xstats *stats = to_xstats(kobject);
> 
> nitpick, tab before *stats to line it all up.
> 
> > +
> > +	return xfs_stats_format(stats->xs_stats, buf);
> >  }
> >  XFS_SYSFS_ATTR_RO(stats);
> >  
> > @@ -148,6 +159,7 @@ stats_clear_store(
> >  {
> >  	int		ret;
> >  	int		val;
> > +	struct xstats *stats = to_xstats(kobject);
> 
> nitpick, tab before *stats to line it all up.
> 
> Thanks,
> -Eric
> 
> >  
> >  	ret = kstrtoint(buf, 0, &val);
> >  	if (ret)
> > @@ -155,7 +167,8 @@ stats_clear_store(
> >  
> >  	if (val != 1)
> >  		return -EINVAL;
> > -	xfs_stats_clearall();
> > +
> > +	xfs_stats_clearall(stats->xs_stats);
> >  	return count;
> >  }
> >  XFS_SYSFS_ATTR_WO(stats_clear);
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
