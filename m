Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F4187F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 03:32:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E9C6304053
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 01:32:35 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xcGmgIxpwCZkfgS3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 01:32:31 -0800 (PST)
Date: Thu, 27 Nov 2014 10:32:25 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: no quota output if no usage?
Message-ID: <20141127093225.GB30152@quack.suse.cz>
References: <5476297F.8080304@sandeen.net> <20141126212144.GD9561@dastard>
	<54764582.6000005@sandeen.net> <20141126221845.GE9561@dastard>
	<54767030.7070706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54767030.7070706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed 26-11-14 18:28:32, Eric Sandeen wrote:
> On 11/26/14 4:18 PM, Dave Chinner wrote:
> 
> >> Or am I missing something ...
> > 
> > Nope, I'm confusing different reporting command behaviour....
> 
> Ok, so back to the original question: think it's cool to drop
> the verbose requirement to find out limits when there is 0 usage?
  Just as a data point quota(1) command from quota-tools also doesn't
report quota entries where no space & inode is accounted without -v option.
I never thought it's particularly useful but apparently it's some heritage
from the original implementation of quota in some Unix and so I decided to
maintain compatibility...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
