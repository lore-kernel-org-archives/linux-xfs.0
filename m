Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5N9mOG0020991 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 04:48:25 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 397441079273
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 02:57:11 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id udykhcDOQyFpBzXS for <xfs@oss.sgi.com>;
	Tue, 23 Jun 2009 02:57:11 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [Acl-devel] Re: getfacl gives octal output for Hebrew user/group
	names
Date: Tue, 23 Jun 2009 11:48:01 +0200
References: <4A38F04C.9090909@linux.vnet.ibm.com>
	<200906191917.45817.agruen@suse.de>
	<4A3F3304.1080901@linux.vnet.ibm.com>
In-Reply-To: <4A3F3304.1080901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906231148.02088.agruen@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: acl-devel@nongnu.org
Cc: Anoop Vijayan <acv@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Monday 22 June 2009 09:30:12 Anoop Vijayan wrote:
> Also, acl_entry_to_any_str() in libacl/__acl_to_any_text.c calls quote.
> I could not find the corresponding unquote calls for these.

See acl_from_text() and several functions in setfacl/parse.c.

> If I wrap the above quote() calls with unquote(), the problem seems to be
> resolved. Attaching a patch for the same.

Yes, but this only proves that the quote and unquote functions work as 
intended, it doesn't help fix the underlying problem at all that special 
characters in file, user, or group names can mess up the output.

I have updated the quoting code in the acl and attr packages now so that it 
will only quote a few special characters line newline, carriage return, and a 
few delimiter characters. So this should work for Hebrew or other special 
characters now.

Note that there is no way to not quote backslash as backslash is the escape 
character used, so Samba names of the form "domain\user" will still be quoted. 
It's possible to teach winbindd to use a different character; otherwise, 
you'll have to live with the quoting.)

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
