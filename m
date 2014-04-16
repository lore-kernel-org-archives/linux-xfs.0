Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36B557F66
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:18:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F2D0304087
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:18:16 -0700 (PDT)
Received: from emvm-gh1-uea09.nsa.gov (emvm-gh1-uea09.nsa.gov [63.239.67.10])
	by cuda.sgi.com with ESMTP id GoD7uG8F1I9Rg5bF for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:18:15 -0700 (PDT)
Message-ID: <534E903B.7060305@tycho.nsa.gov>
Date: Wed, 16 Apr 2014 10:14:19 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
	<20140415175033.GB26404@infradead.org>
	<534D90D0.9090805@tycho.nsa.gov>
	<20140415202222.GA10928@infradead.org>
	<534D94E4.8070606@tycho.nsa.gov> <534E7CDA.2060805@tycho.nsa.gov>
	<20140416141409.GA21743@infradead.org>
In-Reply-To: <20140416141409.GA21743@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Moore <paul@paul-moore.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>

On 04/16/2014 10:14 AM, Christoph Hellwig wrote:
> On Wed, Apr 16, 2014 at 08:51:38AM -0400, Stephen Smalley wrote:
>> Maybe I spoke too soon.  IIUC, I_LINKABLE doesn't necessarily
>> distinguish tmpfiles from other files, as some tmpfiles may be linkable
>> and others not.  But what we want is a way to identify all tmpfiles when
>> security_inode_init_security() is called if we are going to label them
>> independently of the provided dir.
> 
> Oh, right.  If O_EXCL is specified (another annoying overload of the
> flag..) the tmpfile can't ever be linked back into the filesystem
> and thus doesn't have I_LINKABLE set.
> 
> I guess the best way to fix this is using the magic qstr you suggested
> before.  That means security_inode_init_security would need to be
> called after d_tmpfile, which most filesystems don't do right now.

I think one could just pass NULL for the qstr as an indicator, which
ext4 already does, so it doesn't require moving after d_tmpfile) IIUC.
However, that doesn't solve the problem for security_inode_create(),
which also needs to know it is dealing with a tmpfile.  So we might want
to just pass an explicit flag to both.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
