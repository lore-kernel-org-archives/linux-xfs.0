Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:33851 "EHLO mx142.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbeDFACn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 20:02:43 -0400
From: "Vairavanathan, Emalayan" <Emalayan.Vairavanathan@netapp.com>
Subject: [Question] Behaviour of directory listing in XFS with concurrent
 deletes
Date: Thu, 5 Apr 2018 23:53:18 +0000
Message-ID: <BLUPR0601MB0929603CF85A26259FA94D32F1BB0@BLUPR0601MB0929.namprd06.prod.outlook.com>
Content-Language: en-CA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hi There,


We have an application that  iterates through a large directory (that has a=
round 1.2 million files)  and lists the names of all the files in the direc=
tory.=20

Files stored in the directory could be concurrently deleted by another thre=
ad in the application while the application lists the files.=20

Our application can tolerate false positives when listing a directory. Howe=
ver false negatives in directory listing *cannot* be tolerated.

To this end could someone tell  me how=A0directory listing in XFS behaves w=
ith concurrent deletes? Is it  possible to see false negatives ?

Thank you
 Emalayan=
