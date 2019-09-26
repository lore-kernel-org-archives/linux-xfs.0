Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE485C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 03:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89AB4222BF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 03:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfIZDcP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 23:32:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48786 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfIZDcP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 23:32:15 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDKVm-00042W-Pt; Thu, 26 Sep 2019 03:32:10 +0000
Date:   Thu, 26 Sep 2019 04:32:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
Message-ID: <20190926033210.GS26530@ZenIV.linux.org.uk>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933135322.20933.2166438700224340142.stgit@fedora-28>
 <20190924143725.GA17688@bfoster>
 <b9906ced64736b043b6537c61ce60182d92d63e8.camel@themaw.net>
 <20190925143309.GD21991@bfoster>
 <4ffaefd2ec14ea2379feb7aa78d8e29a872efc70.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffaefd2ec14ea2379feb7aa78d8e29a872efc70.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 10:57:48AM +0800, Ian Kent wrote:

> > Ok, so I'm not terribly familiar with the core mount code in the
> > first
> > place. Can you elaborate a bit on the where the whole "source" thing
> > comes from and why/how it's necessary to boot?

device name.  And there's nothing special about boot.

> Your not alone.
> 
> I've pondered over the VFS mount code fairly often over the years
> and I've not seen it before either.
> 
> About all I know is it's needed for rootfs, so I guess it's needed
> to resolve the boot device when no file system is yet mounted and
> a normal path walk can't be done.

Bollocks.  Absolute root is ramfs or tmpfs and we do have mknod done
there.

Root filesystem is a complete red herring.

> Maybe an additional fs_context_purpose needs to be defined, maybe
> FS_CONTEXT_FOR_ROOTFS for example.

NO.  ->purpose should go away, not be extended.  And again, that
has fuck-all to do with rootfs.

> That's probably the cleanest way to handle it, not sure it would
> properly cover the cases though.
> 
> That wouldn't be an entirely trivial change so David and Al would
> likely need to get involved and Linus would need to be willing to
> accept it.

> > BTW, this all implies there is some reason for an fs to handle the
> > "source" option, so what happens if one actually does? ISTM the
> > ->parse_param() callout would return 0 and vfs_parse_fs_param() would
> > skip its own update of fc->source. Hm?
> 
> As I understand it that's not a problem because the file system
> will need to have converted the parameter value to some "source"
> value usable by the kernel.
 
For fsck sake...  It's where the first argument of mount(2) goes.
As in, "/dev/sda4" when you say mount -t xfs /dev/sda4 /mnt
Or "10.1.1.18:/srv/nfs/mirrors" in
mount -t nfs4 10.1.1.18:/srv/nfs/mirrors /home/mirrors/public \
	 -o rsize=8192,wsize=8192,proto=tcp,ro

Note that it's not in any real sense different from any other
option - its interpretation is entirely up to fs type.  The
only reason why it's separate is historical - way, way back
there had been no filesystem types and mount(2) got just
a block device pathname + mountpoint + one flag (ro/rw).
No (string) options either.  There has been a long and nasty
history, considerably older than Linux, including such things
as magical binary structures (each for its own fs type - check
how e.g.  OSF is doing that).

But accidents of calling conventions aside, device name is just
another fs option.  And device name is a misnomer - witness
what e.g. NFS is doing.  Keeping it special for new API
was pointless, so we have this in vfs_kern_mount():
        fc = fs_context_for_mount(type, flags);
        if (IS_ERR(fc))
                return ERR_CAST(fc);

        if (name)
                ret = vfs_parse_fs_string(fc, "source",
                                          name, strlen(name));
        if (!ret)
                ret = parse_monolithic_mount_data(fc, data);  
        if (!ret)
                mnt = fc_mount(fc);
        else   
                mnt = ERR_PTR(ret);

        put_fs_context(fc); 

and sys_mount() ends up passing the first argument as 'name' to
vfs_kern_mount().  That's it - nothing more to it.
