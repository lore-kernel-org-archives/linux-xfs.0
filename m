Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36034 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdCDAve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 19:51:34 -0500
Received: by mail-qk0-f175.google.com with SMTP id 1so84136175qkl.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 16:51:33 -0800 (PST)
Message-ID: <1488588201.11672.4.camel@redhat.com>
Subject: Re: [RFC PATCH v1 29/30] fs: track whether the i_version has been
 queried with an i_state flag
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 03 Mar 2017 19:43:21 -0500
In-Reply-To: <87wpc5lxg6.fsf@notabene.neil.brown.name>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <1482339827-7882-30-git-send-email-jlayton@redhat.com>
         <87wpc5lxg6.fsf@notabene.neil.brown.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neil@brown.name>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, 2017-03-04 at 11:03 +1100, NeilBrown wrote:
> On Wed, Dec 21 2016, Jeff Layton wrote:
> 
> > @@ -2072,7 +2093,12 @@ inode_cmp_iversion(const struct inode *inode, const u64 old)
> >  static inline bool
> >  inode_iversion_need_inc(struct inode *inode)
> >  {
> > -	return true;
> > +	bool ret;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	ret = inode->i_state & I_VERS_BUMP;
> > +	spin_unlock(&inode->i_lock);
> > +	return ret;
> >  }
> >  
> 
> I know this code gets removed, so this isn't really important.
> By why do you take the spinlock here?  What are you racing again?
> 
> Thanks,
> NeilBrown

I think I was worried about I_VERS_BUMP being set or cleared during an
increment or query. It is quite possible that that spinlock is not
necessary.
-- 
Jeff Layton <jlayton@redhat.com>
