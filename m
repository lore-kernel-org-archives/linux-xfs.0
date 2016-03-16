Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 624EB7CDE
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 22:29:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25607304039
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 20:29:06 -0700 (PDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	wx4l5R4OSX4VN6G4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 20:29:04 -0700 (PDT)
Received: by mail-ig0-f182.google.com with SMTP id nk17so82447985igb.1
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 20:29:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160315201700.GA22945@sernet.de>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<20160315071103.GC19747@infradead.org> <20160315154514.GB39038@jra3>
	<20160315201700.GA22945@sernet.de>
From: Steve French <smfrench@gmail.com>
Date: Tue, 15 Mar 2016 22:28:44 -0500
Message-ID: <CAH2r5mt1SBnxnu=c8JGA1dmUUcHXG+wYXfWFQCcbC1tZT0BHpQ@mail.gmail.com>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
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
To: "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Cristoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, Jeremy Allison <jra@samba.org>

On Tue, Mar 15, 2016 at 3:17 PM, Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
> On Tue, Mar 15, 2016 at 08:45:14AM -0700, Jeremy Allison wrote:
>> On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
>> > People have long learned that we only have 'alloc' permissions.  Any
>> > model that mixes allow and deny ACE is a mistake.
>>
>> People can also learn and change though :-). One of the
>> biggest complaints people deploying Samba on Linux have is the
>> incompatible ACL models.
>
> Just to confirm: I see this a lot in the field. NFSv4 ACLs, while not a
> perfect match for NTFS ACLs are a lot closer much more usable to people
> who want to serve Windows clients.

Yes (and presumably Macs as well)



-- 
Thanks,

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
