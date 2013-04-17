Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 687397F53
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 09:51:13 -0500 (CDT)
Message-ID: <516EB6E3.9040903@sgi.com>
Date: Wed, 17 Apr 2013 09:51:15 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
	<CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
In-Reply-To: <CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Boris Ranto <ranto.boris@gmail.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Boris,

Most people do not install xfstests, as it is not required to run the 
tests.  Is there a reason you need to install xfstests? It is designed 
to be run from the directory you did the git clone from.  Path is not 
critical so you could move it anywhere you wish.

i.e.
git clone git://oss.sgi.com/xfs/cmds/xfstests
mv xfstests /new/path/new_xfsdirname
cd /new/path/new_xfsdirname
./check -g auto


--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
