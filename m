Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56814 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdCPRT3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 13:19:29 -0400
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
References: <20170315160017.27805-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <79cc8aa4-9ff0-07cb-9f88-755239d4311f@sandeen.net>
Date: Thu, 16 Mar 2017 10:19:26 -0700
MIME-Version: 1.0
In-Reply-To: <20170315160017.27805-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>

On 3/15/17 8:59 AM, Jan Tulak wrote:
> Hi guys,
> 
> my RFC didn't got much of attention, so I'm sending it as a merge request.
> Hopefully, this will get more eyes on it. ;-) I fixed the few small issues Bill
> noticed (Thanks, Bill!) and xfstests runs ok. There is one case where test
> xfs/191-input-validation was accepting a behaviour forbidden in man page, so
> I'm sending also a xfstests patch:
> 
> Specifically, a standalone "-l size=4096b" should fail, because:
>               To  specify any options on the command line in units of filesys‐
>               tem blocks, this option must be  specified  first  so  that  the
>               filesystem block size is applied consistently to all options.
> 
> So without the xfstest patch, expect this one test to fail.
> 
> The following text is copy&paste from RFC. I only removed/edited one question
> I had at the time and was solved in the RFC thread. After that is an addendum
> with regards to Luis' config file support.

Hi Jan -

I'm finally trying to take some time and give this serious review.

At a top level, though, please fix up coding style issues which are
introduced throughout the series.

As Dave has said before, checkpatch.pl in the kernel tree isn't perfect,
and we need to apply understanding and reason to its results, but it's
a place to start looking - for a sampling,

WARNING: please, no space before tabs
#29: FILE: mkfs/xfs_mkfs.c:59:
+#define D_SUNIT ^I4$

ERROR: space required before the open brace '{'
#117: FILE: mkfs/xfs_mkfs.c:147:
+	}	switch(a_type){

(also switch shouldn't be on the same line as the closing brace)

ERROR: space required before the open brace '{'
#119: FILE: mkfs/xfs_mkfs.c:149:
+		switch(b_type){

ERROR: space prohibited before open square bracket '['
#417: FILE: mkfs/xfs_mkfs.c:458:
+		}		conflicts [MAX_CONFLICTS];

WARNING: line over 80 characters
#992: FILE: mkfs/xfs_mkfs.c:779:
+		"V2 attribute format always enabled on CRC enabled filesytems."},

(usually we tab that sort of thing back to fit if possible)

WARNING: Avoid unnecessary line continuations
#1006: FILE: mkfs/xfs_mkfs.c:793:
+					  .message = \

ERROR: space prohibited after that open parenthesis '('
#1976: FILE: mkfs/xfs_mkfs.c:1963:
+		if ( (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||

(and it may be an > 80-char line; again judgement here, this
might be hard to make nice)

ERROR: space required before the open brace '{'
#2042: FILE: mkfs/xfs_mkfs.c:2030:
+	if (sp->seen){

ERROR: else should follow close brace '}'
#2097: FILE: mkfs/xfs_mkfs.c:2082:
+	}
+	else if (opts->index == OPT_S ||

ERROR: space required before the open parenthesis '('
#4104: FILE: mkfs/xfs_mkfs.c:4158:
+	if(conflict->message) {


and many, many more.  

So use your good judgement, but please fix as many of these as you can;
it's important to have a consistent coding style throughout the xfsprogs
codebase.

Thanks,
-Eric
