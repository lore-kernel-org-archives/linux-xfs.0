Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBD497F5D
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:31:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9919D304048
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:31:18 -0700 (PDT)
Received: from mail01.lsn.net (mail01.lsn.net [66.90.130.120]) by cuda.sgi.com
	with ESMTP id 15nnJ8nOpEu7klmS for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:31:16 -0700 (PDT)
Message-ID: <540FA9DB.20000@mygrande.net>
Date: Tue, 09 Sep 2014 20:31:07 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net> <540F9FE9.7070500@mygrande.net>
	<3E40936B-A1F2-424D-B0B3-54B6C7B50B13@filmlight.ltd.uk>
In-Reply-To: <3E40936B-A1F2-424D-B0B3-54B6C7B50B13@filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Sean Caron <scaron@umich.edu>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/2014 8:10 PM, Roger Willcocks wrote:
>
> On 10 Sep 2014, at 01:48, Leslie Rhorer <lrhorer@mygrande.net> wrote:
>
>>   The only ones remaining at issue are 3 files which cannot be read, written or deleted.
>
> The most straightforward fix would be to note down the inode numbers of the three fies and then use xfs_db to clear the inodes; then run xfs_repair again.
>
> See:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_How_to_get_around_a_bad_inode_repair_is_unable_to_clean_up

	That sounds reasonable.  If no one has any more sound advice, I think I 
will try that.


> but before that try running the latest (3.2.1 I think) xfs_repair.

	I am always reticent to run anything outside the distro package.  Ive 
had problems in the past with doing so.  3.1.7 is pretty close, so 
unless there is a really solid reason to use 3.2.1 vs. 3.1.7, I think I 
will stick with the distro version and try the above.  Can you or anyone 
else give a reason why 3.2.1 would work when 3.1.7 would not?  More 
importantly, is there some reason 3.1.7 would make things worse while 
3.2.1 would not?  If not, then I can always try 3.1.7 and then try 3.2.1 
if that does not help.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
