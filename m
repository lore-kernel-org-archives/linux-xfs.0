Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:32821 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbeEVTha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 15:37:30 -0400
Received: by mail-pl0-f68.google.com with SMTP id n10-v6so11504414plp.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 12:37:30 -0700 (PDT)
Date: Tue, 22 May 2018 12:37:26 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180522193726.GA24593@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <20180518004404.GF23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518004404.GF23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Fri, May 18, 2018 at 10:44:04AM +1000, Dave Chinner wrote:
> On Thu, May 17, 2018 at 12:27:00PM -0700, Luis R. Rodriguez wrote:
> > +}
> > +
> > +static enum parse_line_type parse_get_line_type(const char *line, char *tag,
> > +						bool *value)
> > +{
> > +	int ret;
> > +	unsigned int uint_value;
> > +
> > +	memset(tag, 0, 80);
> 
> Why? This should be done in the caller, and if there's a fixed
> buffer size, then please use a #define.

I've modified to use 'm' specifier on scanf().

Using 'm' tells scanf() to allocate a buffer for us, this is easier as
we then enable the parser to do as it sees fit so long as the patterns
match. We just have to later free it after use.

That removes the need to memset() and stick to a predefined buffer sizes
for the tags (section or subopt name).

  Luis
