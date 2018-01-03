Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbeACQ2S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 11:28:18 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1514919462.3462.18.camel@kernel.org>
References: <1514919462.3462.18.camel@kernel.org> <20171222120556.7435-6-jlayton@kernel.org> <20171222120556.7435-1-jlayton@kernel.org> <5112.1514913610@warthog.procyon.org.uk>
Subject: Re: [PATCH v4 05/19] afs: convert to new i_version API
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14422.1514996892.1@warthog.procyon.org.uk>
Date: Wed, 03 Jan 2018 16:28:12 +0000
Message-ID: <14423.1514996892@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, jaltman@auristor.com

Jeff Layton <jlayton@kernel.org> wrote:

> Thanks! I updated that part of the the commit log to read:
> 
>     Note that AFS has quite a different definition for this counter. AFS
>     only increments it on changes to the data to the data in regular files
>     and contents of the directories. Inode metadata changes do not result
>     in a version increment.

Sounds good.

David
