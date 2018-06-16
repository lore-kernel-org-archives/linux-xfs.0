Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753624AbeFPAFB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 20:05:01 -0400
Date: Sat, 16 Jun 2018 02:04:59 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
Message-ID: <20180616000459.GS5527@wotan.suse.de>
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard>
 <20180614062949.GA6825@magnolia>
 <20180614174640.GE7508@wotan.suse.de>
 <20180614175909.GB8128@magnolia>
 <20180614181602.GL5527@wotan.suse.de>
 <20180614183528.GC8128@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614183528.GC8128@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 11:35:28AM -0700, Darrick J. Wong wrote:
> Section headers:
> n = sscanf(line, " [ %m[^] \f\n\r\t\v] %ms %m[^\n]", &tag, &cp, &junk);
> 
> We pick up the section name (in *tag) if cp == "]" and n == 2 (i.e.
> there's no junk at the end of the line.
> 
> "# some comment"
> "[data]"
> "[data] # some comment"
> " [data]"
> "[ data]"
> "[data ]"
> "[data] "
> <repeat but with tabs instead of spaces>
> 
> "[data] noalign = 1"
> "[data cow]"
> "[data"
> "data]"
> " [data cow]"
> "[ data cow]"
> "[data cow]"
> "[data cow ]"
> "[data cow] "
> "[data.cow]"
> "[data noalign = 1]"
> "[nonexistentsection]"
> 
> Key/value:
> 
> n = sscanf(line, " %m[^][ \f\n\r\t\v=] %m[=] %m[^\n]", &key, &eq, &val);
> 
> We pick up the key/value pair if n == 3, eq == "]" and *key is found in
> the current section header, and if *val can be stroull'd.
> 
> Assuming a [data] section,
> 
> "# some comment"
> "noalign=1"
> "noalign=1 # some comment"
> " noalign=1"
> "noalign =1"
> "noalign= 1"
> "noalign=1 "
> " noalign =1"
> " noalign= 1"
> " noalign=1 "
> "noalign = 1"
> "noalign =1 "
> "noalign= 1 "
> " noalign = 1"
> " noalign= 1 "
> "noalign = 1 "
> <repeat with tabs>
> 
> "noalign moo = 1"
> "noalign is 1"
> "noalign = 10"
> "noalign = 109825091285091825091285018250"
> "noalign = [metadata]"
> "moocow"
> "moocow = 5"

I tried some stuff but I could not get it to barf. Can you send me some
config file attachments which do make it puke? Or patches? :)

  Luis
