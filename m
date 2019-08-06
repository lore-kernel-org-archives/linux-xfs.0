Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35700 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfHFMCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 08:02:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so76155818wmg.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2019 05:02:50 -0700 (PDT)
Date: Tue, 6 Aug 2019 14:02:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190806120245.3qestwolyjtaky5u@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
 <20190731231217.GV1561054@magnolia>
 <20190802091937.kwutqtwt64q5hzkz@pegasus.maiolino.io>
 <20190802151400.GG7138@magnolia>
 <20190805102729.ooda6sg65j65ojd4@pegasus.maiolino.io>
 <20190805151258.GD7129@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805151258.GD7129@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

I'll keep my reply to your email short here, because hch's follow-up email
summarizes what I wanted to say, so I'll reply to his email directly.

> : 	return bno;
> : }
> 
> > returned. And IIRC, iomap is the only interface now that cares about issuing a
> > warning.
> >
> > I think the *best* we could do here, is to make the new bmap() to issue the same
> > kind of WARN() iomap does, but we can't really change the end result.
> 
> I'd rather we break legacy code than corrupt filesystems.

By now, I wish to apologize Darrick, it was my fault to not pay enough attention
to iomap's bmap implementation as you mentioned. Will keep the discussion topic
on next e-mail.


-- 
Carlos
