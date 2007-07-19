Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 21:49:21 -0700 (PDT)
Received: from agminet02.oracle.com (agminet02.oracle.com [141.146.126.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6J4nDbm007442
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 21:49:15 -0700
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l6J3gAOp019626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 22:42:10 -0500
Date: Wed, 18 Jul 2007 20:41:55 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Message-ID: <20070719034155.GE32734@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713184625.GB12156@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com, michael.kerrisk@gmx.net

On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> After a successful call, subsequent writes are guaranteed not to fail because
> of lack of disk space.
  
If a write to an unwritten region requires a node split, that could result
in the allocation of new meta data which obviously could fail if the disk is
truly full.

Granted that's unlikely to happen but maybe we should be conservative and
say something like:

"After a successful call, subsequent writes are guaranteed to never require
allocation of file data." ?
        --Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
