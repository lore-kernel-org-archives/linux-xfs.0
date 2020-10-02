Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAF7C4727E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 02:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5078720796
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 02:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgJBCgG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 22:36:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45623 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727780AbgJBCgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 22:36:05 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 22:36:04 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 769085C00B3;
        Thu,  1 Oct 2020 22:27:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 01 Oct 2020 22:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        6SZJj7woaJNMouirMLheU9bxMmTos3MOPUbL+P+tBIY=; b=imjUhqss/+/U7+V/
        vcZDg3aFH5Kb9mTAfgxdNpbY50owiWxBoB1tcdnaDtm+cEY5masjMm4ApnO0vl4K
        hHSoSeswlng3ruJe3128OXSG1jL++3Mo18a0sKs5HvBawbmTfmCyMOzusYirWmVn
        Zli/5jcT8KFoEO4sLoOh6W0hGzQik1qtCruRyIlEmdXD686PekdzXUf8Oeflj/3v
        U/ABtsS16h+2FblXz65mwlm/0xs4GMqyjyOMxy/j1c1f03Ftya7i5zZyLP+ursQ/
        9Ydw+aW5CzwGL/dQreLSV4spUrSlDnHetaVSOQD8H9ciNwsnRlLK2XbRv8QIqTDR
        2BmxbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=6SZJj7woaJNMouirMLheU9bxMmTos3MOPUbL+P+tB
        IY=; b=eDi+v/N6TrwITObXYOeLRtXRy4ap65R/dYG85V3hsq0EmO5FTfbFevpPc
        wUEoaTDOamIBM2h+dlGkXob19jifMFH/ou56Th8M6fLjSGaop7L/JB02GIgAhM25
        VJp2dqMrWL2JwUnb2ae6mKIiBDa2c6uGYTC6k1+KAGohjwBXwC2XDrJTB03w62Gy
        ps3/A94xL+wAVdj01LKacxgOFW6Ht/gm10c/jTP5A97TZtfloSWT0xE6r3u7yY1Y
        zcmKu+XlAvhzv3iTYDZ9gBGH9pF+s6AoFVkyKhKo5O5mUHXiQXLbrxLP1PKbiARg
        qR+DgpDfQyRRA2KWbyg3rxby2tV4Q==
X-ME-Sender: <xms:IZB2X144r5xlKvZEUQ9pL53-yxJH2ySjH1q9kVstPYXnUdXronz36g>
    <xme:IZB2Xy6Q3eUJfntbULn-sU5KMhpl9fD-DcB6UcGXYY3vfTL2JG4J1RTzTPDXkqzro
    pSJUNQwYtqy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfeehgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvdefledrvdehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:IZB2X8cPqLRE7k_nc5tp3XNh0kRQQf5AbrXszSpEuQT2uUZRUvfAsw>
    <xmx:IZB2X-LtEkxkAcAE6QZolxztVs57X1VtblDSrxkZgO-XSJJygE-47w>
    <xmx:IZB2X5IZZOomFzw0bd5p7AIU6bhGmmiAZOKVxTawY6hA9z4FvltmDA>
    <xmx:IZB2X-UQfxpuITe-q8muE8fZ5pHuclFgdf-Wj15GzTAf2itpU_JCWg>
Received: from mickey.themaw.net (106-69-239-253.dyn.iinet.net.au [106.69.239.253])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFCCC3064610;
        Thu,  1 Oct 2020 22:27:43 -0400 (EDT)
Message-ID: <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Date:   Fri, 02 Oct 2020 10:27:39 +0800
In-Reply-To: <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
         <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2020-10-01 at 16:22 -0500, Eric Sandeen wrote:
> On 9/30/20 8:06 PM, Ian Kent wrote:
> > Some of the xfsprogs utilities read the mount table via.
> > getmntent(3).
> > 
> > The mount table may contain (almost always these days since
> > /etc/mtab is
> > symlinked to /proc/self/mounts) autofs mount entries. During
> > processing
> > of the mount table entries statfs(2) can be called on mount point
> > paths
> > which will trigger an automount if those entries are direct or
> > offset
> > autofs mount triggers (indirect autofs mounts aren't affected).
> > 
> > This can be a problem when there are a lot of autofs direct or
> > offset
> > mounts because real mounts will be triggered when statfs(2) is
> > called.
> > This can be particularly bad if the triggered mounts are NFS mounts
> > and
> > the server is unavailable leading to lengthy boot times or worse.
> > 
> > Simply ignoring autofs mount entries during getmentent(3)
> > traversals
> > avoids the statfs() call that triggers these mounts. If there are
> > automounted mounts (real mounts) at the time of reading the mount
> > table
> > these will still be seen in the list so they will be included if
> > that
> > actually matters to the reader.
> > 
> > Recent glibc getmntent(3) can ignore autofs mounts but that
> > requires the
> > autofs user to configure autofs to use the "ignore" pseudo mount
> > option
> > for autofs mounts. But this isn't yet the autofs default (to
> > prevent
> > unexpected side effects) so that can't be used.
> > 
> > The autofs direct and offset automount triggers are pseudo file
> > system
> > mounts and are more or less useless in terms on file system
> > information
> > so excluding them doesn't sacrifice useful file system information
> > either.
> > 
> > Consequently excluding autofs mounts shouldn't have any adverse
> > side
> > effects.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fsr/xfs_fsr.c   |    3 +++
> >  libfrog/linux.c |    2 ++
> >  libfrog/paths.c |    2 ++
> >  3 files changed, 7 insertions(+)
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index 77a10a1d..466ad9e4 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -323,6 +323,9 @@ initallfs(char *mtab)
> >  	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
> >  		int rw = 0;
> >  
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> > +
> >  		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
> >  		    stat(mnt->mnt_fsname, &sb) == -1 ||
> >  		    !S_ISBLK(sb.st_mode))
> > 			continue;
> 
> Forgive me if I'm missing something obvious but isn't this added
> check redundant?
> 
> If mnt_type == "autofs" then mnt_type != MNTTYPE_XFS and we're
> ignoring it
> already in this loop, no?  In this case, the loop is for xfs_fsr so
> we are really
> only ever going to be looking for xfs mounts, as opposed to
> fs_table_initialise_mounts
> which may accept "foreign" (non-xfs) filesystems.
> 
> > diff --git a/libfrog/linux.c b/libfrog/linux.c
> > index 40a839d1..a45d99ab 100644
> > --- a/libfrog/linux.c
> > +++ b/libfrog/linux.c
> > @@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block,
> > struct stat *s, int flags)
> >  	 * servers.  So first, a simple check: does the "dev" start
> > with "/" ?
> >  	 */
> >  	while ((mnt = getmntent(f)) != NULL) {
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> >  		if (mnt->mnt_fsname[0] != '/')
> >  			continue;
> 
> Same sort of question here, but I don't know what these autofs
> entries look like.
> Can their "device" (mnt_fsname) begin with "/" ?

It can, I fiddle with the device so it corresponds to the map
name and if that's a path, like /etc/auto.indirect, it will start
with a "/".

> 
> Backing up a bit, which xfsprogs utility saw this behavior with
> autofs mounts?

IIRC the problem I saw ended up being with xfs_spaceman invoked
via udisksd on mount/umount activity. There may be other cases so
I'd rather not assume there won't be problems elsewhere but those
checks for an xfs fs that I didn't notice probably need to change.

> 
> I'm mostly ok with just always and forever filtering out anything
> that matches
> "autofs" but if it's unnecessary (like the first case I think?) it
> may lead
> to confusion for future code readers.

I've got feedback from Darrick too, so let me think about what should
be done.

What I want out of this is that autofs mounts don't get triggered when
I start autofs for testing when xfs is the default (root) file system.
If it isn't the default file system this behaviour mostly doesn't
happen.

My basic test setup has a couple of hundred direct autofs mounts in
two or three maps and they all get mounted when starting autofs.

I'm surprised we haven't had complaints about it TBH but people might
not have noticed it since they expire away if they don't actually
get used.

Ian

> 
> Thanks,
> -Eric
> 
> >  		if (stat(mnt->mnt_dir, &mst) < 0)
> > diff --git a/libfrog/paths.c b/libfrog/paths.c
> > index 32737223..d6793764 100644
> > --- a/libfrog/paths.c
> > +++ b/libfrog/paths.c
> > @@ -389,6 +389,8 @@ fs_table_initialise_mounts(
> >  			return errno;
> >  
> >  	while ((mnt = getmntent(mtp)) != NULL) {
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> >  		if (!realpath(mnt->mnt_dir, rmnt_dir))
> >  			continue;
> >  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> > 
> > 

