Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C689B7F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:25:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5A198F8049
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:25:55 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id EnwwHEVp56Xnoljq (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:25:53 -0700 (PDT)
Date: Tue, 15 Apr 2014 20:25:50 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] check: add support for an external test expunging file
Message-ID: <20140416002550.GB12078@thunk.org>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
	<20140416001530.GU15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416001530.GU15995@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 10:15:30AM +1000, Dave Chinner wrote:
> > If the argument to the -X option is a pathname (that is, includes a
> > '/' character), treat it as the latter case.  If it the argument to
> > the -X option is just a bare filename (that is, does not include '/'
> > character), treat it as the former.
> 
> Can you add a new option rather than overloading the existing one
> with new meanings and semantics?

If that's your preference, sure.  How does --expunge-list-file strike
you?  Or would you prefer something else?  I'm easy.  :-)

      	       	   	  	    	       - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
