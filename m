Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754152AbdFWJQK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 05:16:10 -0400
Date: Fri, 23 Jun 2017 11:16:06 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/4] xfs: expose errortag knobs via sysfs
Message-ID: <20170623091606.l2tdplgaohnfyt5r@eorzea.usersys.redhat.com>
References: <149800747210.23118.6423951814449227184.stgit@birch.djwong.org>
 <149800748451.23118.6326280252461129051.stgit@birch.djwong.org>
 <20170621181918.GC29843@bfoster.bfoster>
 <20170621183955.GK4733@birch.djwong.org>
 <20170621185354.GF29843@bfoster.bfoster>
 <20170621204532.GP4733@birch.djwong.org>
 <20170622151557.uav3coiicdh3kdye@eorzea.usersys.redhat.com>
 <20170622172953.GU4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622172953.GU4733@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

> > Wouldn't be better to move these stuff into xfs_sysfs.c? We already
> > have there such macros, or, if keeping debug stuff into xfs_error.c
> > looks more sane than adding the #ifdef DEBUG to xfs_sysfs.c maybe
> > moving those common macros/inlines (such as to_mp()) to a common
> > header makes more sense?
> 
> But they're not the same to_mp and to_attr -- we file all the debugging
> knobs under errortag/, which is a separate kobj from the xfs_mount one.
> to_attr is different because we've created a new structure with a tag
> number that also avoids the store/show function pointer redirection of
> the regular xfs_attr structure.  I could refactor xfs_attr to store a
> tag and update all the related functions, but for an initial RFC I
> didn't want to spend time wading through all the macros.
> 
> I chose to keep all the errortag stuff together in xfs_error.c since all
> the code is related functionality.  That's mostly a reflection of my
> competing distastes for spreading tuning knob code over multiple files
> vs. letting all the sysfs macro gooeyness spread everywhere.  Since the
> tuning knobs are all a class unto themselves, I figured it was fine to
> put them in xfs_error.c
> 
Fair enough.

> > > > > > > +
> > > > > > > +STATIC ssize_t
> > > > > > > +xfs_errortag_attr_store(
> > > > > > > +	struct kobject		*kobject,
> > > > > > > +	struct attribute	*attr,
> > > > > > > +	const char		*buf,
> > > > > > > +	size_t			count)
> > > > > > > +{
> > > > > > > +	struct xfs_mount	*mp = to_mp(kobject);
> > > > > > > +	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
> > > > > > > +	int			ret;
> > > > > > > +	unsigned int		val;
> > > > > > > +
> > > > > > > +	if (strcmp(buf, "on") == 0) {
> > > > > > > +		val = xfs_errortag_random_default[xfs_attr->tag];
> > > > > > 
> > > > > > I'm also wondering if we really care to preserve this. It doesn't seem
> > > > > > like something we would add if we were adding this mechanism from
> > > > > > scratch, for example, but I could be wrong. Obviously this isn't from
> > > > > > scratch, but I kind of view this as morphing the old mechanism into
> > > > > > something slightly new (while preserving the old interface).
> > > > > 
> > > > > I debated whether or not to port every aspect of the old ioctl to this
> > > > > new interface.  My thought was that the current ioctl applies whatever
> > > > > default the kernel has, so therefore the sysfs interface needs a kludge
> > > > > to preserve that feature because the current crop of test cases accept
> > > > > the kernel defaults.  We /could/ change the xfstests helper to supply
> > > > > the default value to sysfs if the test doesn't otherwise provide a
> > > > > value, but on an old kernel there's no way to figure out if the value
> > > > > set was the value you wanted, so if the value you supply is the same as
> > > > > the encoded default then try the ioctl and if it succeeds then maybe the
> > > > > injection is set up the way the test wants?  Ick.
> > > > > 
> > > > 
> > > > I'm a little confused... is there any reason we can't keep the ioctl()
> > > > interface around (and in use by the existing xfstests helpers) for the
> > > > purpose of preserving this traditional "hardcoded default" behavior?
> > > > Anything that uses/expects kernel provided settings can just continue to
> > > > use the existing interface. Anything new or that wants finer grained
> > > > control can use sysfs.
> > > 
> > > I think I confused myself and everyone else about this point.  I wasn't
> > > planning to get rid of the old ioctl, but then went off into the weeds
> > > over "what if we ever did remove it".
> > > 
> > > Sooo... this is my vision:
> > > 
> > > The ioctl will retain the behavior that you can only set the value to
> > > the default; it will not let you set the value if it's already been
> > > turned on; and the only way to turn off any of the error tags is to
> > > clear all of them.
> > > 
> > > The sysfs interface will let you set the values to anything you want at
> > > any time, including 0 (off) or "default".
> > > 
> > 
> > I don't want to add more fire to it, but, do we gain any benefit in
> > keeping both interfaces? It just sounds confusing to me. Bear in mind
> > though, I've never played with the ioctl() interface, that's why I'm
> > asking if there is any benefit in keeping them both :)
> 
> It depends on how we handle userspace.  It's tempting to deprecate the
> ioctl in favor of setting the sysfs knobs and switch xfstests over to
> the sysfs knobs via a bash function helper that figures out which
> interface is available.
> 
> That said, if we /do/ decide to drop the ioctl, we ought to have a
> deprecation schedule to give people time to absorb new xfstests.  Being
> a debug feature that schedule can be much shorter than usual, but I
> don't want to have a flag day just for this. :)
> 
I agree with you here, I can give a hand deprecating the old ioctl in the
hopefully not too far future if you want, just give me a heads up.

Regarding the whole patch series with these error knobs, I liked it, it I
discussed it a bit with Brian yesterday, and as we already spoke about, will be
useful to even implement a xfstests regarding the dm-thin stuff I'm working on.

I have the xfstests for that case almost done though, using fsfreeze to test the
bug fix.

Do you plan to remove the RFC flag from this patchset soon? I can wait in this
case and send a xfstests based on this feature (I'll need to implement some
extra knob to force a buffer error, but that is simple with this patchset), or
just keep the current plan with fsfreeze (suggested by Brian btw), send it ASAP,
and update it in the future.

What you think?

Cheers

> (FWIW I hate the ioctl interface and want it to die.)
> 
> --D
> 
> > 
> > cheers
> > 
> > > > > Then again it's a debug interface that historically didn't check the
> > > > > error tag being input either, so.... :(
> > > > > 
> > > > > Also, maybe "default" would have been a better choice for the value?
> > > > > 
> > > > 
> > > > I do like "default" better than "on" if we want to keep the ability to
> > > > set the associated value via sysfs.
> > > 
> > > Ok.
> > > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > > --D
> > > > > 
> > > > > > I'll probably need to stare a bit more at the sysfs bits, but otherwise
> > > > > > the rest all seems fine to me at first glance.
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > +	} else {
> > > > > > > +		ret = kstrtouint(buf, 0, &val);
> > > > > > > +		if (ret)
> > > > > > > +			return ret;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	ret = xfs_errortag_set(mp, xfs_attr->tag, val);
> > > > > > > +	if (ret)
> > > > > > > +		return ret;
> > > > > > > +	return count;
> > > > > > > +}
> > > > > > > +
> > > > > > > +STATIC ssize_t
> > > > > > > +xfs_errortag_attr_show(
> > > > > > > +	struct kobject		*kobject,
> > > > > > > +	struct attribute	*attr,
> > > > > > > +	char			*buf)
> > > > > > > +{
> > > > > > > +	struct xfs_mount	*mp = to_mp(kobject);
> > > > > > > +	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
> > > > > > > +
> > > > > > > +	return snprintf(buf, PAGE_SIZE, "%u\n",
> > > > > > > +			xfs_errortag_get(mp, xfs_attr->tag));
> > > > > > > +}
> > > > > > > +
> > > > > > > +static const struct sysfs_ops xfs_errortag_sysfs_ops = {
> > > > > > > +	.show = xfs_errortag_attr_show,
> > > > > > > +	.store = xfs_errortag_attr_store,
> > > > > > > +};
> > > > > > > +
> > > > > > > +#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
> > > > > > > +static struct xfs_errortag_attr xfs_errortag_attr_##_name = {		\
> > > > > > > +	.attr = {.name = __stringify(_name),				\
> > > > > > > +		 .mode = VERIFY_OCTAL_PERMISSIONS(S_IWUSR | S_IRUGO) },	\
> > > > > > > +	.tag	= (_tag),						\
> > > > > > > +}
> > > > > > > +
> > > > > > > +#define XFS_ERRORTAG_ATTR_LIST(_name) &xfs_errortag_attr_##_name.attr
> > > > > > > +
> > > > > > > +XFS_ERRORTAG_ATTR_RW(noerror,		XFS_ERRTAG_NOERROR);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush1,		XFS_ERRTAG_IFLUSH_1);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush2,		XFS_ERRTAG_IFLUSH_2);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush3,		XFS_ERRTAG_IFLUSH_3);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush4,		XFS_ERRTAG_IFLUSH_4);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush5,		XFS_ERRTAG_IFLUSH_5);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iflush6,		XFS_ERRTAG_IFLUSH_6);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(dareadbuf,		XFS_ERRTAG_DA_READ_BUF);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(btree_chk_lblk,	XFS_ERRTAG_BTREE_CHECK_LBLOCK);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(btree_chk_sblk,	XFS_ERRTAG_BTREE_CHECK_SBLOCK);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(readagf,		XFS_ERRTAG_ALLOC_READ_AGF);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(readagi,		XFS_ERRTAG_IALLOC_READ_AGI);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(itobp,		XFS_ERRTAG_ITOBP_INOTOBP);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iunlink,		XFS_ERRTAG_IUNLINK);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(iunlinkrm,		XFS_ERRTAG_IUNLINK_REMOVE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(dirinovalid,	XFS_ERRTAG_DIR_INO_VALIDATE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(bulkstat,		XFS_ERRTAG_BULKSTAT_READ_CHUNK);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(logiodone,		XFS_ERRTAG_IODONE_IOERR);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(stratread,		XFS_ERRTAG_STRATREAD_IOERR);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(stratcmpl,		XFS_ERRTAG_STRATCMPL_IOERR);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(diowrite,		XFS_ERRTAG_DIOWRITE_IOERR);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(bmapifmt,		XFS_ERRTAG_BMAPIFORMAT);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(free_extent,	XFS_ERRTAG_FREE_EXTENT);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(rmap_finish_one,	XFS_ERRTAG_RMAP_FINISH_ONE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(refcount_continue_update,	XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(refcount_finish_one,	XFS_ERRTAG_REFCOUNT_FINISH_ONE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(bmap_finish_one,	XFS_ERRTAG_BMAP_FINISH_ONE);
> > > > > > > +XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
> > > > > > > +
> > > > > > > +static struct attribute *xfs_errortag_attrs[] = {
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(noerror),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush1),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush2),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush3),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush4),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush5),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iflush6),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(dareadbuf),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(btree_chk_lblk),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(btree_chk_sblk),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(readagf),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(readagi),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(itobp),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iunlink),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(iunlinkrm),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(dirinovalid),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(bulkstat),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(logiodone),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(stratread),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(stratcmpl),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(diowrite),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(bmapifmt),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(free_extent),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(rmap_finish_one),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(refcount_continue_update),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(refcount_finish_one),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(bmap_finish_one),
> > > > > > > +	XFS_ERRORTAG_ATTR_LIST(ag_resv_critical),
> > > > > > > +	NULL,
> > > > > > > +};
> > > > > > > +
> > > > > > > +struct kobj_type xfs_errortag_ktype = {
> > > > > > > +	.release = xfs_sysfs_release,
> > > > > > > +	.sysfs_ops = &xfs_errortag_sysfs_ops,
> > > > > > > +	.default_attrs = xfs_errortag_attrs,
> > > > > > > +};
> > > > > > > +
> > > > > > >  int
> > > > > > >  xfs_errortag_init(
> > > > > > >  	struct xfs_mount	*mp)
> > > > > > > @@ -64,13 +204,16 @@ xfs_errortag_init(
> > > > > > >  			KM_SLEEP | KM_MAYFAIL);
> > > > > > >  	if (!mp->m_errortag)
> > > > > > >  		return -ENOMEM;
> > > > > > > -	return 0;
> > > > > > > +
> > > > > > > +	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
> > > > > > > +			       &mp->m_kobj, "errortag");
> > > > > > >  }
> > > > > > >  
> > > > > > >  void
> > > > > > >  xfs_errortag_del(
> > > > > > >  	struct xfs_mount	*mp)
> > > > > > >  {
> > > > > > > +	xfs_sysfs_del(&mp->m_errortag_kobj);
> > > > > > >  	kmem_free(mp->m_errortag);
> > > > > > >  }
> > > > > > >  
> > > > > > > @@ -96,6 +239,17 @@ xfs_errortag_test(
> > > > > > >  }
> > > > > > >  
> > > > > > >  int
> > > > > > > +xfs_errortag_get(
> > > > > > > +	struct xfs_mount	*mp,
> > > > > > > +	unsigned int		error_tag)
> > > > > > > +{
> > > > > > > +	if (error_tag >= XFS_ERRTAG_MAX)
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > > +	return mp->m_errortag[error_tag];
> > > > > > > +}
> > > > > > > +
> > > > > > > +int
> > > > > > >  xfs_errortag_set(
> > > > > > >  	struct xfs_mount	*mp,
> > > > > > >  	unsigned int		error_tag,
> > > > > > > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > > > > > > index 341e8a0..a3c0c1d 100644
> > > > > > > --- a/fs/xfs/xfs_error.h
> > > > > > > +++ b/fs/xfs/xfs_error.h
> > > > > > > @@ -138,6 +138,7 @@ extern bool xfs_errortag_test(struct xfs_mount *mp, const char *expression,
> > > > > > >  #define XFS_TEST_ERROR(expr, mp, tag, rf)		\
> > > > > > >  	((expr) || xfs_errortag_test((mp), #expr, __FILE__, __LINE__, (tag)))
> > > > > > >  
> > > > > > > +extern int xfs_errortag_get(struct xfs_mount *mp, unsigned int error_tag);
> > > > > > >  extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
> > > > > > >  		unsigned int tag_value);
> > > > > > >  extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
> > > > > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > > > > index e002ac5..931e9fc 100644
> > > > > > > --- a/fs/xfs/xfs_mount.h
> > > > > > > +++ b/fs/xfs/xfs_mount.h
> > > > > > > @@ -204,6 +204,7 @@ typedef struct xfs_mount {
> > > > > > >  	 * error triggers.  1 = always, 2 = half the time, etc.
> > > > > > >  	 */
> > > > > > >  	unsigned int		*m_errortag;
> > > > > > > +	struct xfs_kobj		m_errortag_kobj;
> > > > > > >  
> > > > > > >  	/*
> > > > > > >  	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
> > > > > > > 
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
