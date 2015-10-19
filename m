Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 861817F59
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:35:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73A55304053
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 08:35:00 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	HKf0skJflmqSXMuD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 08:34:56 -0700 (PDT)
Received: by lbcao8 with SMTP id ao8so146517555lbc.3
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 08:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5624ED40.7040206@gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
Date: Mon, 19 Oct 2015 17:34:54 +0200
Message-ID: <CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>
>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> I would like to re-iterate, on both XFS and ext4, I _really_ think this
>>> should be a ro_compat flag, and not an incompat one.  If a person has the
>>> ability to mount the FS (even if it's a read-only mount), then they by
>>> definition have read access to the file or partition that the filesystem
>>> is contained in, which means that any ACL's stored on the filesystem are
>>> functionally irrelevant,
>>
>> It is unfortunately not safe to make such a file system accessible to
>> other users, so the feature is not strictly read-only compatible.
>>
> OK, seeing as I wasn't particularly clear as to why I object to this in my
> other e-mail, let's try this again.
>
> Can you please explain exactly why it isn't safe to make such a filesystem
> accessible to other users?

See here: http://www.spinics.net/lists/linux-ext4/msg49541.html

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
