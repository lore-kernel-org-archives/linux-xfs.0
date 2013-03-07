Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 344BE7FAF
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:22:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19D65304059
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 03:22:37 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EZ3frZ6jSQVy2YJp for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 03:22:36 -0800 (PST)
Date: Thu, 7 Mar 2013 12:22:35 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests 273: fix a typo
Message-ID: <20130307112235.GK21081@twin.jikos.cz>
References: <512DAC1A.2040601@gmail.com> <20130306232222.GF21081@twin.jikos.cz>
	<20130307033849.GB6369@dastard>
	<20130307110600.GJ21081@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307110600.GJ21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
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
To: dsterba@suse.cz, Dave Chinner <david@fromorbit.com>, Wang Sheng-Hui <shhuiw@gmail.com>, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 12:06:01PM +0100, David Sterba wrote:
> (Also tried to build a git tree, but filterdiff did not produce 1:1 unified
> format of the separate patches and there are lots of conflicts).

I'm too git-centric and wanted to use 'git apply', but the 'patch'
utility is able to apply context diffs just fine, so now tested with
"GNU bash, version 4.2.42(2)-release"

$ bash-4.2/bash 273
273: line 4: syntax error near unexpected token `&'
273: line 4: `cp -r origin target >seq.full 2>>&1'

http://www.gnu.org/software/bash/manual/html_node/Redirections.html
does not list the syntactic construct as valid.


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
